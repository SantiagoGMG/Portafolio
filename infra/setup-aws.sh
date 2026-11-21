#!/usr/bin/env bash
# One-time AWS setup for the portfolio: private S3 bucket + CloudFront (OAC) + GitHub OIDC deploy role + $1 budget alert.
# Everything here stays inside the AWS free tier / always-free limits.
#
# Usage (Git Bash, with valid `aws configure` credentials of an admin user):
#   GITHUB_REPO="SantiagoGMG/Portafolio" BUCKET="santiagogmg-portfolio" ALERT_EMAIL="you@example.com" bash infra/setup-aws.sh
set -euo pipefail

: "${GITHUB_REPO:?Set GITHUB_REPO=owner/repo}"
: "${BUCKET:?Set BUCKET=globally-unique-bucket-name}"
: "${ALERT_EMAIL:?Set ALERT_EMAIL for the budget alert}"
REGION="${REGION:-us-east-1}"
BRANCH="${BRANCH:-master}"
ROLE_NAME="github-portfolio-deploy"
export AWS_PAGER=""

# Temp dir as a Windows-style path when running in Git Bash, so aws.exe can read file:// arguments
TMP="$(mktemp -d)"
if command -v cygpath >/dev/null 2>&1; then TMP="$(cygpath -m "$TMP")"; fi

# aws.exe on Windows ends lines with \r; strip it from captured values
awst() { aws "$@" --output text | tr -d '\r'; }

ACCOUNT_ID="$(awst sts get-caller-identity --query Account)"
echo "Account: $ACCOUNT_ID  Region: $REGION  Bucket: $BUCKET  Repo: $GITHUB_REPO"

# 1. Private bucket (Block Public Access is on by default)
if ! aws s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET" --region "$REGION"
  else
    aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" \
      --create-bucket-configuration LocationConstraint="$REGION"
  fi
fi
aws s3api put-public-access-block --bucket "$BUCKET" --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# 2. Origin Access Control (CloudFront signs requests to the private bucket)
OAC_ID="$(awst cloudfront create-origin-access-control --origin-access-control-config \
  "Name=${BUCKET}-oac,SigningProtocol=sigv4,SigningBehavior=always,OriginAccessControlOriginType=s3" \
  --query OriginAccessControl.Id)"

# 3. CloudFront distribution (HTTPS, caching optimized, cheapest price class)
cat > "$TMP/dist.json" <<EOF
{
  "CallerReference": "portfolio-$(date +%s)",
  "Comment": "Portfolio ${BUCKET}",
  "Enabled": true,
  "DefaultRootObject": "index.html",
  "PriceClass": "PriceClass_100",
  "HttpVersion": "http2and3",
  "Origins": { "Quantity": 1, "Items": [{
    "Id": "s3-origin",
    "DomainName": "${BUCKET}.s3.${REGION}.amazonaws.com",
    "OriginAccessControlId": "${OAC_ID}",
    "S3OriginConfig": { "OriginAccessIdentity": "" }
  }]},
  "DefaultCacheBehavior": {
    "TargetOriginId": "s3-origin",
    "ViewerProtocolPolicy": "redirect-to-https",
    "CachePolicyId": "658327ea-f89d-4fab-a63d-7e88639e58f6",
    "Compress": true,
    "AllowedMethods": { "Quantity": 2, "Items": ["GET", "HEAD"] }
  },
  "CustomErrorResponses": { "Quantity": 1, "Items": [{
    "ErrorCode": 403, "ResponsePagePath": "/index.html", "ResponseCode": "200", "ErrorCachingMinTTL": 60
  }]}
}
EOF
read -r DIST_ID DIST_DOMAIN < <(awst cloudfront create-distribution --distribution-config "file://$TMP/dist.json" \
  --query 'Distribution.[Id,DomainName]')

# 4. Bucket policy: only this distribution can read
cat > "$TMP/bucket-policy.json" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "AllowCloudFrontRead",
    "Effect": "Allow",
    "Principal": { "Service": "cloudfront.amazonaws.com" },
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${BUCKET}/*",
    "Condition": { "StringEquals": { "AWS:SourceArn": "arn:aws:cloudfront::${ACCOUNT_ID}:distribution/${DIST_ID}" } }
  }]
}
EOF
aws s3api put-bucket-policy --bucket "$BUCKET" --policy "file://$TMP/bucket-policy.json"

# 5. GitHub OIDC provider (once per account)
OIDC_ARN="arn:aws:iam::${ACCOUNT_ID}:oidc-provider/token.actions.githubusercontent.com"
if ! aws iam get-open-id-connect-provider --open-id-connect-provider-arn "$OIDC_ARN" >/dev/null 2>&1; then
  aws iam create-open-id-connect-provider --url https://token.actions.githubusercontent.com \
    --client-id-list sts.amazonaws.com --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
fi

# 6. Deploy role: only pushes to $BRANCH of this repo can assume it
cat > "$TMP/trust.json" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "Federated": "${OIDC_ARN}" },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
        "token.actions.githubusercontent.com:sub": "repo:${GITHUB_REPO}:ref:refs/heads/${BRANCH}"
      }
    }
  }]
}
EOF
cat > "$TMP/perms.json" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    { "Effect": "Allow", "Action": "s3:ListBucket", "Resource": "arn:aws:s3:::${BUCKET}" },
    { "Effect": "Allow", "Action": ["s3:PutObject", "s3:DeleteObject"], "Resource": "arn:aws:s3:::${BUCKET}/*" },
    { "Effect": "Allow", "Action": "cloudfront:CreateInvalidation",
      "Resource": "arn:aws:cloudfront::${ACCOUNT_ID}:distribution/${DIST_ID}" }
  ]
}
EOF
if aws iam get-role --role-name "$ROLE_NAME" >/dev/null 2>&1; then
  aws iam update-assume-role-policy --role-name "$ROLE_NAME" --policy-document "file://$TMP/trust.json"
else
  aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document "file://$TMP/trust.json" >/dev/null
fi
aws iam put-role-policy --role-name "$ROLE_NAME" --policy-name deploy --policy-document "file://$TMP/perms.json"
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"

# 7. $1 monthly budget with email alert (budgets are free)
cat > "$TMP/budget.json" <<EOF
{ "BudgetName": "portfolio-1usd", "BudgetLimit": { "Amount": "1", "Unit": "USD" },
  "TimeUnit": "MONTHLY", "BudgetType": "COST" }
EOF
cat > "$TMP/notif.json" <<EOF
[{ "Notification": { "NotificationType": "ACTUAL", "ComparisonOperator": "GREATER_THAN", "Threshold": 1, "ThresholdType": "PERCENTAGE" },
   "Subscribers": [{ "SubscriptionType": "EMAIL", "Address": "${ALERT_EMAIL}" }] }]
EOF
aws budgets create-budget --account-id "$ACCOUNT_ID" --budget "file://$TMP/budget.json" \
  --notifications-with-subscribers "file://$TMP/notif.json" 2>/dev/null || echo "(budget already exists, skipped)"

rm -rf "$TMP"

cat <<EOF

Done. Add these in GitHub -> repo Settings -> Secrets and variables -> Actions:

  Secret    AWS_ROLE_ARN               = ${ROLE_ARN}
  Variable  AWS_REGION                 = ${REGION}
  Variable  S3_BUCKET                  = ${BUCKET}
  Variable  CLOUDFRONT_DISTRIBUTION_ID = ${DIST_ID}

Your site (after the first deploy, CloudFront takes ~5 min to be ready):
  https://${DIST_DOMAIN}
EOF

# SantiagoGMG · Portfolio

Personal portfolio of **Santiago Gael May Góngora**, a Data Engineer and Software Technologies Engineering student at the Autonomous University of Campeche (UACAM).

🔗 **Live site:** _add your CloudFront URL here_

## Tech stack

- [Vue 3](https://vuejs.org/) + [Vite](https://vite.dev/)
- [PrimeVue 4](https://primevue.org/) (Aura theme, dark mode) + PrimeIcons
- All content lives in a single JSON file
- Hosted on **AWS S3 + CloudFront**, deployed by **GitHub Actions** on every push to `master`

## Editing content

Everything shown on the site lives in [`public/data/portfolio.json`](public/data/portfolio.json): profile, experience, background, skills, projects and certifications. Each section renders its array with `v-for`.

**To add a project:** put the screenshot in `public/assets/`, then add an object to `projects`:

```json
{
  "title": "My New Project",
  "description": "What it does and how it's built.",
  "image": "assets/my-project.png",
  "tags": ["Python", "AWS"],
  "links": [
    { "label": "Code", "type": "code", "url": "https://github.com/..." },
    { "label": "Demo", "type": "demo", "url": "https://..." }
  ]
}
```

Optional fields:

- `gallery`: a list of images, shown in a full-screen gallery when the card image is clicked.
- `note`: a small line of text under the tags (for example, a demo password).

The link `type` picks the icon: `code`, `demo` or `video`.

**To add a certification:** add an object to `certifications` with `name`, `issuer`, `url`, and optionally `code`, `icon` (a PrimeIcons class) and `verifyLabel`.

Then commit and push to `master`. The site updates in 1–3 minutes.

## Running locally

```bash
npm install
npm run dev       # http://localhost:5173
npm run build     # production build in dist/
npm run preview   # serve the build
```

## Project structure

```
├── index.html                    # Vite entry
├── public/
│   ├── assets/                   # images
│   └── data/portfolio.json       # all site content
├── src/
│   ├── main.js                   # Vue + PrimeVue setup (theme preset)
│   ├── App.vue                   # loads the JSON, composes sections
│   ├── composables/usePortfolio.js
│   ├── components/               # one component per section + ProjectCard
│   └── styles/main.css           # design tokens and shared styles
├── infra/setup-aws.sh            # one-time AWS setup
└── .github/workflows/deploy.yml  # build + deploy on push to master
```

## Deployment (AWS, $0/month)

The setup is a private S3 bucket behind CloudFront, using Origin Access Control and HTTPS. GitHub Actions authenticates to AWS with OIDC, so no AWS keys are stored in the repository. Traffic stays inside CloudFront's always-free tier (1 TB and 10M requests per month), and a $1 AWS Budget sends an email alert if any cost ever shows up.

One-time setup:

1. Configure the AWS CLI with an admin user: `aws configure`.
2. Run:
   ```bash
   GITHUB_REPO="SantiagoGMG/Portafolio" BUCKET="<unique-bucket-name>" ALERT_EMAIL="<your email>" bash infra/setup-aws.sh
   ```
3. Copy the values it prints into GitHub → **Settings → Secrets and variables → Actions**:
   - Secret: `AWS_ROLE_ARN`
   - Variables: `AWS_REGION`, `S3_BUCKET`, `CLOUDFRONT_DISTRIBUTION_ID`
4. Push to `master`, or run the workflow manually from the **Actions** tab.

## Contact

- GitHub: [@SantiagoGMG](https://github.com/SantiagoGMG)
- LinkedIn: [Santiago Gael May Góngora](https://www.linkedin.com/in/santiago-gael-may-g%C3%B3ngora-55b5363bb/)

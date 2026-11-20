<script setup>
import SectionTitle from './SectionTitle.vue'

defineProps({
  certifications: { type: Array, required: true },
})
</script>

<template>
  <section id="certifications" class="section container">
    <SectionTitle index="04" title="Certifications" subtitle="Credentials & courses" />

    <div class="cert-grid">
      <a
        v-for="cert in certifications"
        :key="cert.url"
        :href="cert.url"
        target="_blank"
        rel="noopener"
        class="panel cert"
      >
        <span class="cert-icon"><i :class="cert.icon || 'pi pi-verified'" /></span>
        <div class="cert-body">
          <h3>{{ cert.name }}</h3>
          <p class="meta">
            {{ cert.issuer }}
            <span v-if="cert.code" class="code">{{ cert.code }}</span>
          </p>
          <span class="verify">
            {{ cert.verifyLabel || 'View credential' }} <i class="pi pi-arrow-up-right" />
          </span>
        </div>
      </a>
    </div>
  </section>
</template>

<style scoped>
.cert-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: 1rem;
}

.cert {
  display: flex;
  gap: 1rem;
  padding: 1.25rem;
  color: inherit;
  transition: border-color 0.2s ease;
}

.cert:hover {
  border-color: var(--accent);
}

.cert-icon {
  flex-shrink: 0;
  width: 44px;
  height: 44px;
  display: grid;
  place-items: center;
  border-radius: 10px;
  background: var(--accent-soft);
  color: var(--accent);
  font-size: 1.2rem;
}

h3 {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-strong);
  line-height: 1.35;
}

.meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: var(--text-muted);
  margin: 0.3rem 0 0.75rem;
}

.code {
  font-family: var(--font-mono);
  font-size: 0.75rem;
  padding: 0.1rem 0.45rem;
  border-radius: 6px;
  border: 1px solid var(--border);
  color: var(--text-faint);
}

.verify {
  font-size: 0.85rem;
  color: var(--text-muted);
  transition: color 0.2s ease;
}

.verify i {
  font-size: 0.7rem;
  margin-left: 0.2rem;
}

.cert:hover .verify {
  color: var(--accent);
}
</style>

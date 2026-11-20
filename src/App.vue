<script setup>
import { computed } from 'vue'
import ProgressSpinner from 'primevue/progressspinner'
import { usePortfolio } from './composables/usePortfolio'
import AppHeader from './components/AppHeader.vue'
import HeroSection from './components/HeroSection.vue'
import ExperienceSection from './components/ExperienceSection.vue'
import SkillsSection from './components/SkillsSection.vue'
import ProjectsSection from './components/ProjectsSection.vue'
import CertificationsSection from './components/CertificationsSection.vue'
import ContactSection from './components/ContactSection.vue'

const { data, loading, error } = usePortfolio()

const navLinks = [
  { label: 'Experience', href: '#experience' },
  { label: 'Skills', href: '#skills' },
  { label: 'Projects', href: '#projects' },
  { label: 'Certifications', href: '#certifications' },
  { label: 'Contact', href: '#contact' },
]

const year = new Date().getFullYear()
const handle = computed(() => data.value?.profile.handle ?? 'SantiagoGMG')
</script>

<template>
  <AppHeader :handle="handle" :links="navLinks" />

  <main>
    <div v-if="loading" class="state">
      <ProgressSpinner style="width: 40px; height: 40px" strokeWidth="4" />
    </div>

    <div v-else-if="error" class="state">
      <i class="pi pi-exclamation-triangle state-icon" />
      <p>Couldn't load the portfolio content. Please refresh the page.</p>
    </div>

    <template v-else>
      <HeroSection :profile="data.profile" />
      <ExperienceSection :experience="data.experience" :background="data.background" />
      <SkillsSection :skills="data.skills" />
      <ProjectsSection :projects="data.projects" />
      <CertificationsSection :certifications="data.certifications" />
      <ContactSection :profile="data.profile" />
    </template>
  </main>

  <footer class="footer">
    <div class="container footer-inner">
      <span>&copy; {{ year }} {{ handle }}</span>
      <span class="footer-muted">Built with Vue &amp; PrimeVue · Hosted on AWS</span>
    </div>
  </footer>
</template>

<style scoped>
.state {
  min-height: 70vh;
  display: grid;
  place-items: center;
  align-content: center;
  gap: 1rem;
  color: var(--text-muted);
  text-align: center;
  padding: 0 1rem;
}

.state-icon {
  font-size: 2rem;
  color: var(--accent);
}

.footer {
  border-top: 1px solid var(--border);
  padding: 2rem 0;
  font-size: 0.875rem;
  color: var(--text-muted);
}

.footer-inner {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.footer-muted {
  color: var(--text-faint);
}
</style>

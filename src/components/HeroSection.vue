<script setup>
import Button from 'primevue/button'
import { asset } from '../composables/usePortfolio'

defineProps({
  profile: { type: Object, required: true },
})
</script>

<template>
  <section id="home" class="hero container">
    <div class="hero-text">
      <p class="status">
        <span class="dot" /> {{ profile.location }}
      </p>
      <h1>{{ profile.name }}</h1>
      <p class="role">{{ profile.role }}</p>
      <p class="bio">{{ profile.bio }}</p>

      <div class="actions">
        <Button as="a" href="#projects" label="View projects" icon="pi pi-arrow-right" iconPos="right" />
        <Button as="a" href="#contact" label="Contact me" severity="secondary" outlined />
      </div>

      <div class="socials">
        <a
          v-for="s in profile.socials"
          :key="s.url"
          :href="s.url"
          target="_blank"
          rel="noopener"
          :aria-label="s.label"
        >
          <i :class="s.icon" />
        </a>
      </div>
    </div>

    <img class="photo" :src="asset(profile.photo)" :alt="profile.name" width="280" height="280" />
  </section>
</template>

<style scoped>
.hero {
  min-height: 100vh;
  min-height: 100svh;
  padding-top: 112px;
  padding-bottom: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 4rem;
}

.status {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.85rem;
  color: var(--text-muted);
  border: 1px solid var(--border);
  border-radius: 999px;
  padding: 0.3rem 0.85rem;
  margin-bottom: 1.5rem;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #22c55e;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.2);
}

h1 {
  font-size: clamp(2.2rem, 5.5vw, 3.75rem);
  font-weight: 700;
  line-height: 1.08;
  letter-spacing: -0.035em;
  color: var(--text-strong);
}

.role {
  font-size: clamp(1.15rem, 2.4vw, 1.5rem);
  font-weight: 500;
  color: var(--accent);
  margin: 0.75rem 0 1.25rem;
}

.bio {
  font-size: 1.05rem;
  color: var(--text-muted);
  max-width: 58ch;
  margin-bottom: 2rem;
}

.actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-bottom: 2rem;
}

.socials {
  display: flex;
  gap: 1.25rem;
}

.socials a {
  color: var(--text-muted);
  font-size: 1.25rem;
}

.socials a:hover {
  color: var(--text-strong);
}

.photo {
  width: 280px;
  height: 280px;
  object-fit: cover;
  border-radius: 24px;
  border: 1px solid var(--border);
  flex-shrink: 0;
  filter: saturate(0.95);
}

@media (max-width: 860px) {
  .hero {
    flex-direction: column-reverse;
    align-items: flex-start;
    justify-content: center;
    gap: 2rem;
    min-height: auto;
    padding-top: 104px;
  }

  .photo {
    width: 112px;
    height: 112px;
    border-radius: 50%;
  }
}
</style>

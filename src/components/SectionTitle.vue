<script setup>
defineProps({
  index: { type: String, required: true },
  title: { type: String, required: true },
  subtitle: { type: String, default: '' },
})
</script>

<template>
  <header class="section-title">
    <span class="eyebrow">{{ index }} · {{ title }}</span>
    <h2 v-if="subtitle">{{ subtitle }}</h2>
  </header>
</template>

<style scoped>
.section-title {
  margin-bottom: 2.5rem;
}

.eyebrow {
  display: inline-block;
  font-family: var(--font-mono);
  font-size: 0.8rem;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--accent);
  margin-bottom: 0.75rem;
}

h2 {
  font-size: clamp(1.6rem, 3vw, 2.1rem);
  font-weight: 600;
  letter-spacing: -0.02em;
  color: var(--text-strong);
  max-width: 36ch;
}
</style>

<script setup>
import Button from 'primevue/button'
import SectionTitle from './SectionTitle.vue'

defineProps({
  profile: { type: Object, required: true },
})
</script>

<template>
  <section id="contact" class="section container">
    <div class="panel contact">
      <SectionTitle index="05" title="Contact" subtitle="Let's build something with data" />
      <p class="text">{{ profile.contactText }}</p>

      <div class="actions">
        <Button
          as="a"
          :href="profile.contactUrl"
          target="_blank"
          rel="noopener"
          label="Email me"
          icon="pi pi-envelope"
        />
        <Button
          v-for="s in profile.socials"
          :key="s.url"
          as="a"
          :href="s.url"
          target="_blank"
          rel="noopener"
          :label="s.label"
          :icon="s.icon"
          severity="secondary"
          outlined
        />
      </div>
    </div>
  </section>
</template>

<style scoped>
.contact {
  padding: clamp(1.5rem, 5vw, 3.5rem);
  background:
    radial-gradient(ellipse at top left, var(--accent-soft), transparent 60%),
    var(--surface);
}

.text {
  color: var(--text-muted);
  font-size: 1.05rem;
  margin: -1rem 0 2rem;
}

.actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
}
</style>

<script setup>
import Timeline from 'primevue/timeline'
import SectionTitle from './SectionTitle.vue'

defineProps({
  experience: { type: Array, required: true },
  background: { type: Array, required: true },
})
</script>

<template>
  <section id="experience" class="section container">
    <SectionTitle index="01" title="Experience" subtitle="Where I've been building" />

    <div class="grid">
      <div>
        <h3 class="col-title">Work</h3>
        <Timeline :value="experience" class="timeline">
          <template #marker>
            <span class="marker" />
          </template>
          <template #content="{ item }">
            <article class="job">
              <p class="period">{{ item.period }}</p>
              <h4>
                <a v-if="item.url" :href="item.url" target="_blank" rel="noopener">{{ item.org }}</a>
                <template v-else>{{ item.org }}</template>
              </h4>
              <p class="job-role">{{ item.role }}</p>
              <p class="job-desc">{{ item.description }}</p>
            </article>
          </template>
        </Timeline>
      </div>

      <div>
        <h3 class="col-title">Background</h3>
        <ul class="background">
          <li v-for="item in background" :key="item">
            <i class="pi pi-check-circle" />
            <span>{{ item }}</span>
          </li>
        </ul>
      </div>
    </div>
  </section>
</template>

<style scoped>
.grid {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 3rem;
}

.col-title {
  font-size: 0.85rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: var(--text-faint);
  margin-bottom: 1.25rem;
}

/* Left-aligned timeline: hide the empty "opposite" column */
.timeline :deep(.p-timeline-event-opposite) {
  display: none;
}

.timeline :deep(.p-timeline-event-connector) {
  background: var(--border);
}

.marker {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  border: 2px solid var(--accent);
  background: var(--bg);
}

.job {
  padding: 0 0 1.5rem 0.5rem;
}

.period {
  font-family: var(--font-mono);
  font-size: 0.8rem;
  color: var(--text-faint);
  margin-bottom: 0.25rem;
}

h4 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-strong);
}

h4 a {
  color: inherit;
}

h4 a:hover {
  color: var(--accent);
}

.job-role {
  color: var(--accent);
  font-size: 0.95rem;
  margin: 0.15rem 0 0.5rem;
}

.job-desc {
  color: var(--text-muted);
  font-size: 0.95rem;
}

.background {
  list-style: none;
  display: grid;
  gap: 0.85rem;
}

.background li {
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  color: var(--text-muted);
  font-size: 0.95rem;
}

.background i {
  color: var(--accent);
  margin-top: 0.25rem;
}

@media (max-width: 760px) {
  .grid {
    grid-template-columns: 1fr;
    gap: 2.5rem;
  }
}
</style>

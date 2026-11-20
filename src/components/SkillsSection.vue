<script setup>
import SectionTitle from './SectionTitle.vue'

defineProps({
  skills: { type: Array, required: true },
})
</script>

<template>
  <section id="skills" class="section container">
    <SectionTitle index="02" title="Skills" subtitle="Tools I work with" />

    <div class="skills-grid">
      <div v-for="group in skills" :key="group.category" class="panel group">
        <h3>{{ group.category }}</h3>
        <ul>
          <li v-for="item in group.items" :key="item" class="chip">{{ item }}</li>
        </ul>
      </div>
    </div>
  </section>
</template>

<style scoped>
.skills-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 300px), 1fr));
  gap: 1rem;
}

.group {
  padding: 1.25rem;
}

h3 {
  font-size: 0.95rem;
  font-weight: 600;
  color: var(--text-strong);
  margin-bottom: 1rem;
}

ul {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}
</style>

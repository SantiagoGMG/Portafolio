<script setup>
import SectionTitle from './SectionTitle.vue'
import ProjectCard from './ProjectCard.vue'

defineProps({
  projects: { type: Array, required: true },
})
</script>

<template>
  <section id="projects" class="section container">
    <SectionTitle index="03" title="Projects" subtitle="Selected work" />

    <div class="projects-grid">
      <ProjectCard v-for="project in projects" :key="project.title" :project="project" />
    </div>
  </section>
</template>

<style scoped>
.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(min(100%, 320px), 1fr));
  gap: 1.5rem;
}
</style>

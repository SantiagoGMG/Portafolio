<script setup>
import { computed, ref } from 'vue'
import Button from 'primevue/button'
import Galleria from 'primevue/galleria'
import { asset } from '../composables/usePortfolio'

const props = defineProps({
  project: { type: Object, required: true },
})

const LINK_ICONS = {
  code: 'pi pi-github',
  demo: 'pi pi-external-link',
  video: 'pi pi-youtube',
}

const expanded = ref(false)
const galleryOpen = ref(false)

// Every card opens the full-screen viewer: the gallery if there is one, otherwise just the cover image
const gallery = computed(() =>
  (props.project.gallery?.length ? props.project.gallery : [props.project.image])
    .map((src) => ({ src: asset(src), alt: `${props.project.title} screenshot` })),
)
const multiple = computed(() => gallery.value.length > 1)
const isLong = computed(() => props.project.description.length > 220)
</script>

<template>
  <article class="panel card">
    <button
      type="button"
      class="media media-button"
      :aria-label="`Enlarge ${project.title} screenshot`"
      @click="galleryOpen = true"
    >
      <img :src="asset(project.image)" :alt="`${project.title} screenshot`" loading="lazy" />
      <span v-if="multiple" class="media-badge"><i class="pi pi-images" /> {{ gallery.length }}</span>
      <span class="media-zoom"><i class="pi pi-search-plus" /></span>
    </button>

    <div class="body">
      <h3>{{ project.title }}</h3>

      <p class="desc" :class="{ clamped: isLong && !expanded }">{{ project.description }}</p>
      <button v-if="isLong" type="button" class="more" @click="expanded = !expanded">
        {{ expanded ? 'Show less' : 'Read more' }}
      </button>

      <ul v-if="project.tags?.length" class="tags">
        <li v-for="tag in project.tags" :key="tag" class="chip chip-sm">{{ tag }}</li>
      </ul>

      <p v-if="project.note" class="note"><i class="pi pi-key" /> {{ project.note }}</p>

      <div v-if="project.links?.length" class="links">
        <Button
          v-for="link in project.links"
          :key="link.url"
          as="a"
          :href="link.url"
          target="_blank"
          rel="noopener"
          :label="link.label"
          :icon="LINK_ICONS[link.type] ?? 'pi pi-link'"
          size="small"
          severity="secondary"
          text
        />
      </div>
    </div>

    <Galleria
      v-model:visible="galleryOpen"
      :value="gallery"
      :numVisible="5"
      fullScreen
      :circular="multiple"
      :showItemNavigators="multiple"
      :showThumbnails="false"
      :showIndicators="multiple"
      showIndicatorsOnItem
      containerStyle="max-width: min(1100px, 92vw)"
    >
      <template #item="{ item }">
        <img :src="item.src" :alt="item.alt" class="gallery-img" />
      </template>
    </Galleria>
  </article>
</template>

<style scoped>
.card {
  display: flex;
  flex-direction: column;
  overflow: hidden;
  transition: border-color 0.2s ease;
}

.card:hover {
  border-color: var(--border-strong);
}

.media {
  position: relative;
  aspect-ratio: 16 / 9;
  background: var(--bg);
  border-bottom: 1px solid var(--border);
  overflow: hidden;
}

.media-button {
  display: block;
  width: 100%;
  padding: 0;
  border: 0;
  border-bottom: 1px solid var(--border);
  cursor: zoom-in;
  font: inherit;
}

.media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.card:hover .media img {
  transform: scale(1.03);
}

.media-badge {
  position: absolute;
  right: 0.75rem;
  bottom: 0.75rem;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.75rem;
  padding: 0.25rem 0.6rem;
  border-radius: 999px;
  background: rgba(11, 15, 23, 0.8);
  color: var(--text-strong);
  border: 1px solid var(--border);
}

/* Magnifier hint that fades in on hover/focus */
.media-zoom {
  position: absolute;
  inset: 0;
  display: grid;
  place-items: center;
  background: rgba(11, 15, 23, 0.35);
  color: var(--text-strong);
  font-size: 1.6rem;
  opacity: 0;
  transition: opacity 0.2s ease;
}

.media-button:hover .media-zoom,
.media-button:focus-visible .media-zoom {
  opacity: 1;
}

.body {
  padding: 1.25rem;
  display: flex;
  flex-direction: column;
  flex: 1;
}

h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: var(--text-strong);
  margin-bottom: 0.5rem;
}

.desc {
  color: var(--text-muted);
  font-size: 0.925rem;
}

.desc.clamped {
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.more {
  align-self: flex-start;
  background: none;
  border: 0;
  padding: 0;
  margin-top: 0.35rem;
  color: var(--accent);
  font: inherit;
  font-size: 0.85rem;
  cursor: pointer;
}

.tags {
  list-style: none;
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  margin-top: 1rem;
}

.note {
  margin-top: 0.85rem;
  font-size: 0.825rem;
  color: var(--text-faint);
}

.note i {
  font-size: 0.75rem;
  margin-right: 0.25rem;
}

.links {
  display: flex;
  flex-wrap: wrap;
  gap: 0.25rem;
  margin-top: auto;
  padding-top: 1rem;
  margin-left: -0.75rem;
}

.gallery-img {
  display: block;
  max-width: 100%;
  max-height: 82vh;
  object-fit: contain;
}
</style>

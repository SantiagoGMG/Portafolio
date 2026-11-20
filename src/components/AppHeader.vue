<script setup>
import { ref } from 'vue'
import Button from 'primevue/button'

defineProps({
  handle: { type: String, required: true },
  links: { type: Array, required: true },
})

const open = ref(false)
</script>

<template>
  <header class="header">
    <div class="container header-inner">
      <a href="#home" class="logo" @click="open = false">
        <span class="logo-mark">&lt;/&gt;</span> {{ handle }}
      </a>

      <nav class="nav" :class="{ open }" aria-label="Main">
        <a v-for="link in links" :key="link.href" :href="link.href" @click="open = false">
          {{ link.label }}
        </a>
      </nav>

      <Button
        class="menu-toggle"
        :icon="open ? 'pi pi-times' : 'pi pi-bars'"
        text
        rounded
        severity="secondary"
        :aria-label="open ? 'Close menu' : 'Open menu'"
        :aria-expanded="open"
        @click="open = !open"
      />
    </div>
  </header>
</template>

<style scoped>
.header {
  position: fixed;
  inset: 0 0 auto 0;
  z-index: 1000;
  background: rgba(11, 15, 23, 0.75);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid var(--border);
}

.header-inner {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo {
  font-weight: 600;
  color: var(--text-strong);
  letter-spacing: -0.01em;
}

.logo-mark {
  font-family: var(--font-mono);
  color: var(--accent);
  margin-right: 0.25rem;
}

.nav {
  display: flex;
  gap: 2rem;
}

.nav a {
  font-size: 0.9rem;
  color: var(--text-muted);
}

.nav a:hover {
  color: var(--text-strong);
}

.menu-toggle {
  display: none;
}

@media (max-width: 760px) {
  .menu-toggle {
    display: inline-flex;
  }

  .nav {
    position: absolute;
    top: 64px;
    left: 0;
    right: 0;
    flex-direction: column;
    gap: 0;
    background: var(--bg);
    border-bottom: 1px solid var(--border);
    padding: 0.5rem 0;
    display: none;
  }

  .nav.open {
    display: flex;
  }

  .nav a {
    padding: 0.85rem 1rem;
    font-size: 1rem;
  }
}
</style>

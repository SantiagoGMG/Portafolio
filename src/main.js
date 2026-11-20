import { createApp } from 'vue'
import PrimeVue from 'primevue/config'
import Aura from '@primeuix/themes/aura'
import { definePreset } from '@primeuix/themes'
import 'primeicons/primeicons.css'
import './styles/main.css'
import App from './App.vue'

// Aura with a blue primary and slate surfaces, dark mode always on (.app-dark on <html>)
const Portfolio = definePreset(Aura, {
  semantic: {
    primary: {
      50: '{blue.50}', 100: '{blue.100}', 200: '{blue.200}', 300: '{blue.300}',
      400: '{blue.400}', 500: '{blue.500}', 600: '{blue.600}', 700: '{blue.700}',
      800: '{blue.800}', 900: '{blue.900}', 950: '{blue.950}',
    },
    colorScheme: {
      dark: {
        surface: {
          0: '#ffffff', 50: '{slate.50}', 100: '{slate.100}', 200: '{slate.200}',
          300: '{slate.300}', 400: '{slate.400}', 500: '{slate.500}', 600: '{slate.600}',
          700: '{slate.700}', 800: '{slate.800}', 900: '#111827', 950: '#0b0f17',
        },
        // Darker backdrop for the image viewer so the page behind doesn't compete
        mask: { background: 'rgba(5, 8, 13, 0.92)', color: '{surface.200}' },
      },
    },
  },
})

createApp(App)
  .use(PrimeVue, {
    theme: {
      preset: Portfolio,
      options: { darkModeSelector: '.app-dark', cssLayer: false },
    },
  })
  .mount('#app')

import { ref } from 'vue'

/** Turns a path from the JSON ("assets/x.png") into a URL that respects Vite's base. */
export const asset = (path) =>
  /^https?:\/\//.test(path) ? path : import.meta.env.BASE_URL + path.replace(/^\//, '')

/** Loads all portfolio content from public/data/portfolio.json. */
export function usePortfolio() {
  const data = ref(null)
  const loading = ref(true)
  const error = ref(null)

  fetch(asset('data/portfolio.json'), { cache: 'no-cache' })
    .then((res) => {
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      return res.json()
    })
    .then((json) => { data.value = json })
    .catch((err) => { error.value = err })
    .finally(() => { loading.value = false })

  return { data, loading, error }
}

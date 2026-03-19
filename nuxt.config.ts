// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  ssr: false, 
  
  app: {
    baseURL: '/easyUpload/', // Maps the internal router to your specific Github sub-domain
    buildAssetsDir: 'assets', // Renames Nuxt's default "/_nuxt/" folder into "/assets/" because Github Pages natively blocks folders starting with an underscore.
  },

  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  modules: [
    '@nuxtjs/tailwindcss',
    '@nuxtjs/supabase'
  ],
  supabase: {
    redirectOptions: {
      login: '/login',
      callback: '/confirm',
      exclude: ['/', '/gallery/*', '/dashboard', '/dashboard/*', '/signup'],
    }
  }
})

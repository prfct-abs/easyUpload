<template>
  <div class="max-w-3xl mx-auto space-y-6 pb-24">
    
    <div>
      <NuxtLink to="/dashboard" class="inline-flex items-center text-sm font-medium text-gray-500 hover:text-indigo-600 mb-4 transition">
        <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
        Back to Galleries
      </NuxtLink>
      <h1 class="text-3xl font-bold tracking-tight text-gray-900">Create New Gallery</h1>
      <p class="text-sm text-gray-500 mt-1">Set up a space for your clients to view and download their moments.</p>
    </div>

    <form @submit.prevent="createGallery" class="bg-white border border-gray-100 rounded-2xl shadow-sm p-6 md:p-8 space-y-8">
      
      <!-- Basics Section -->
      <section class="space-y-6">
        <h2 class="text-lg font-semibold text-gray-900 border-b border-gray-100 pb-2">Gallery Details</h2>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Gallery Title *</label>
          <input v-model="title" type="text" placeholder="e.g. Sarah & John's Wedding" required
                 class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm bg-gray-50 focus:bg-white text-gray-900">
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Event Date</label>
          <input v-model="eventDate" type="date"
                 class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm bg-gray-50 focus:bg-white text-gray-900">
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Client PIN (Optional)</label>
          <input v-model="clientPin" type="text" placeholder="e.g. 5928" maxlength="10"
                 class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm bg-gray-50 focus:bg-white text-gray-900 placeholder-gray-400">
          <p class="text-xs text-gray-500 mt-2">Leave blank for a public gallery.</p>
        </div>
      </section>

      <!-- Advanced Settings Mock -->
      <section class="space-y-6">
        <h2 class="text-lg font-semibold text-gray-900 border-b border-gray-100 pb-2">Download Settings</h2>
        
        <div class="flex items-center justify-between p-4 border border-gray-200 rounded-xl bg-gray-50">
          <div>
            <span class="block text-sm font-medium text-gray-900">Allow High-Res Downloads</span>
            <span class="block text-xs text-gray-500">Clients can download the original 20MB+ files.</span>
          </div>
          <!-- Simple Toggle Switch -->
          <button type="button" @click="allowDownloads = !allowDownloads" :class="['relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-600 focus:ring-offset-2', allowDownloads ? 'bg-indigo-600' : 'bg-gray-200']">
            <span :class="['pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out', allowDownloads ? 'translate-x-5' : 'translate-x-0']"></span>
          </button>
        </div>
      </section>

      <div class="pt-4 flex justify-end">
        <button type="submit" class="px-8 py-3 bg-indigo-600 text-white font-semibold rounded-xl shadow-[0_4px_14px_0_rgb(79,70,229,0.39)] hover:shadow-[0_6px_20px_rgba(79,70,229,0.23)] hover:bg-indigo-700 transition transform hover:-translate-y-0.5" :disabled="loading">
          <span v-if="loading">Creating...</span>
          <span v-else>Continue to Uploader  &rarr;</span>
        </button>
      </div>
    </form>
    
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

definePageMeta({
  layout: 'dashboard'
})

const router = useRouter()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const title = ref('')
const eventDate = ref('')
const clientPin = ref('')
const allowDownloads = ref(true)
const loading = ref(false)

const createGallery = async () => {
  loading.value = true
  
  // Directly verify the session from Supabase Client to avoid Nuxt SSR sync issues
  const { data: { session } } = await supabase.auth.getSession()
  
  if (!session) {
    alert("You must be logged in to create a gallery.")
    loading.value = false
    return
  }

  // Insert the new gallery into our Supabase Postgres Database
  const { data, error } = await supabase
    .from('galleries')
    .insert([
      {
        user_id: session.user.id,
        title: title.value,
        event_date: eventDate.value || null,
        client_pin: clientPin.value || null,
        // For the MVP, we can randomly pull a mock cover image from unsplash if they don't upload one
        cover_image_url: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?auto=format&fit=crop&q=80&w=2600'
      }
    ])
    .select('id')
    .single()

  loading.value = false

  if (error) {
    alert(`Error creating gallery: ${error.message}`)
  } else if (data) {
    // Successfully generated the gallery! Navigate exactly to its unique upload route.
    router.push(`/dashboard/galleries/${data.id}/upload`)
  }
}
</script>

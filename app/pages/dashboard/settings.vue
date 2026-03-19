<template>
  <div class="max-w-4xl mx-auto space-y-8">
    <div class="pb-4 border-b border-gray-100">
      <h1 class="text-3xl font-bold tracking-tight text-gray-900">Settings</h1>
      <p class="text-sm text-gray-500 mt-1">Configure your public profile, watermark, and billing.</p>
    </div>

    <!-- Active Profile Section -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 space-y-8">
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center">
          <svg class="w-5 h-5 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
          Public Profile
        </h2>
        
        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Photographer / Studio Name</label>
            <input v-model="studioName" type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 transition shadow-sm bg-gray-50" placeholder="E.g. EasyUpload Photography" />
            <p class="text-xs text-gray-500 mt-2">This is the title that appears dynamically alongside the pipe separator on all live client galleries you share.</p>
          </div>
          
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Current Login Email</label>
            <input type="email" class="w-full px-4 py-3 border border-gray-200 bg-gray-100 text-gray-500 rounded-lg shadow-sm cursor-not-allowed" disabled :value="user?.email || 'Loading...'" />
            <p class="text-xs text-gray-400 mt-2">To change your primary login email, please contact Support.</p>
          </div>
        </div>
      </section>

      <hr class="border-gray-100" />
      
      <!-- Watermark Section Mock -->
      <section>
        <h2 class="text-xl font-semibold text-gray-900 mb-6 flex items-center">
          <svg class="w-5 h-5 mr-2 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"></path></svg>
          Watermarking <span class="ml-3 inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">Pro Feature</span>
        </h2>
        
        <div class="border-2 border-dashed border-gray-300 rounded-xl p-8 text-center bg-gray-50">
           <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
           <h3 class="mt-2 text-sm font-medium text-gray-900">Upload your logo watermark</h3>
           <p class="mt-1 text-sm text-gray-500">PNG files with transparent backgrounds up to 2MB.</p>
           <div class="mt-4">
             <button type="button" class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 transition cursor-not-allowed opacity-70">
               Select File
             </button>
           </div>
        </div>
      </section>

      <!-- Save Actions -->
      <div class="flex items-center justify-end space-x-4 pt-6 border-t border-gray-100">
        <span v-if="message" class="text-sm font-medium text-emerald-600">{{ message }}</span>
        <button :disabled="loading" class="px-8 py-3 bg-indigo-600 text-white rounded-lg font-bold shadow-md hover:bg-indigo-700 transition transform hover:-translate-y-0.5 disabled:opacity-50" @click="saveSettings">
           {{ loading ? 'Saving...' : 'Save Configuration' }}
        </button>
      </div>

    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

definePageMeta({ layout: 'dashboard' })

const supabase = useSupabaseClient()
const user = useSupabaseUser()

const studioName = ref('')
const loading = ref(false)
const message = ref('')

// Initialize field with current database value
onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  if (session?.user?.user_metadata?.studio_name) {
    studioName.value = session.user.user_metadata.studio_name
  }
})

// Sync field natively with Supabase Auth JSON metadata
const saveSettings = async () => {
  loading.value = true
  message.value = 'Saving across platform...'
  
  const { data: { session } } = await supabase.auth.getSession()
  
  const { error } = await supabase.auth.updateUser({
    data: { studio_name: studioName.value }
  })
  
  if (error) {
    message.value = 'Error saving settings: ' + error.message
  } else {
    message.value = 'Studio Profile saved successfully!'
    setTimeout(() => { message.value = '' }, 3000)
  }
  
  loading.value = false
}
</script>

<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between pb-4 border-b border-gray-100">
      <div>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900">
          <span v-if="dashboardData.studioName" class="font-normal text-indigo-600">{{ dashboardData.studioName }} <span class="mx-2 text-gray-300">|</span> </span> 
          Your Galleries
        </h1>
        <p class="text-sm text-gray-500 mt-2">Manage all your client photo shoots here.</p>
      </div>
      <div class="flex items-center space-x-3">
        <div class="hidden sm:flex bg-gray-100 p-1 rounded-lg">
           <button @click="viewMode = 'grid'" :class="viewMode === 'grid' ? 'bg-white shadow text-gray-900' : 'text-gray-400 hover:text-gray-600'" class="p-1.5 rounded-md transition" title="Grid View">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
           </button>
           <button @click="viewMode = 'list'" :class="viewMode === 'list' ? 'bg-white shadow text-gray-900' : 'text-gray-400 hover:text-gray-600'" class="p-1.5 rounded-md transition" title="List View">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
           </button>
        </div>
        <NuxtLink to="/dashboard/galleries/new" class="flex items-center space-x-2 px-5 py-2.5 bg-indigo-600 text-white rounded-lg font-medium shadow-sm hover:bg-indigo-700 transition">
          <svg class="w-5 h-5 -ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
          <span class="hidden md:inline">New Gallery</span>
          <span class="inline md:hidden">New</span>
        </NuxtLink>
      </div>
    </div>

    <!-- Empty State -->
    <div v-if="!dashboardData.galleries || dashboardData.galleries.length === 0" class="mt-12 text-center py-24 bg-white border border-gray-100 rounded-2xl shadow-sm">
      <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-indigo-50 text-indigo-500 mb-4">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
      </div>
      <h3 class="text-lg font-medium text-gray-900">No galleries yet</h3>
      <p class="mt-1 text-gray-500 max-w-sm mx-auto">Get started by creating a new gallery to upload and share high-resolution photos with your clients.</p>
      <div class="mt-6">
        <NuxtLink to="/dashboard/galleries/new" class="inline-flex items-center space-x-2 px-5 py-2.5 border border-indigo-600 text-indigo-600 rounded-lg font-medium hover:bg-indigo-50 transition">
          <svg class="w-5 h-5 -ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
          <span>Create your first gallery</span>
        </NuxtLink>
      </div>
    </div>
    <!-- Loaded Galleries Dynamic Layout -->
    <div v-else :class="viewMode === 'grid' ? 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 pt-4' : 'flex flex-col space-y-4 pt-4 max-w-5xl'">
      <div v-for="gallery in dashboardData.galleries" :key="gallery.id" 
           class="group bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition flex"
           :class="viewMode === 'grid' ? 'flex-col' : 'flex-col sm:flex-row items-center sm:pr-6'">
        
        <div :class="viewMode === 'grid' ? 'h-48 w-full' : 'h-48 sm:h-28 w-full sm:w-48 flex-shrink-0'" class="bg-gray-200 overflow-hidden relative">
          <img :src="gallery.cover_image_url" class="w-full h-full object-cover group-hover:scale-105 transition duration-500" />
        </div>
        
        <div :class="viewMode === 'grid' ? 'p-5 flex-1 flex flex-col' : 'p-5 sm:p-6 flex-1 flex flex-col sm:flex-row sm:items-center sm:justify-between w-full'">
          
          <div :class="viewMode === 'list' && 'flex-1 pr-4 mb-4 sm:mb-0'">
            <h3 class="text-lg font-bold text-gray-900 truncate">{{ gallery.title }}</h3>
            <div :class="viewMode === 'list' ? 'flex flex-col sm:flex-row sm:items-center sm:space-x-4 mt-1' : ''">
              <p class="text-sm text-gray-500" :class="viewMode === 'grid' && 'mt-1'">{{ gallery.event_date ? new Date(gallery.event_date).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' }) : 'No date set' }}</p>
              <div :class="viewMode === 'grid' ? 'mt-3 mb-6' : 'mt-2 sm:mt-0'">
                <span class="text-xs font-medium px-2.5 py-1 bg-gray-100 text-gray-600 rounded-full">PIN: {{ gallery.client_pin || 'Public' }}</span>
              </div>
            </div>
          </div>
          
          <!-- Explicit Actions Box -->
          <div :class="viewMode === 'grid' ? 'mt-auto grid grid-cols-2 gap-3 border-t border-gray-100 pt-4' : 'flex items-center space-x-3 w-full sm:w-auto'">
            <NuxtLink :to="`/dashboard/galleries/${gallery.id}/upload`" :class="viewMode === 'grid' ? 'w-full py-2' : 'flex-1 sm:flex-none px-5 py-2.5'" class="inline-flex items-center justify-center bg-indigo-50 hover:bg-indigo-100 text-indigo-700 font-medium rounded-lg text-sm transition-colors whitespace-nowrap">
              <svg class="w-4 h-4 mr-1.5 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path></svg>
              Upload
            </NuxtLink>
            
            <NuxtLink :to="`/gallery/${gallery.id}`" target="_blank" :class="viewMode === 'grid' ? 'w-full py-2' : 'flex-1 sm:flex-none px-5 py-2.5'" class="inline-flex items-center justify-center bg-gray-900 hover:bg-black text-white font-medium rounded-lg text-sm transition-colors group-hover:shadow-[0_4px_14px_0_rgba(0,0,0,0.39)] whitespace-nowrap">
              <svg class="w-4 h-4 mr-1.5 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.522 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
              View Live
            </NuxtLink>
          </div>
        </div>
      </div>
    </div>
    
  </div>
</template>

<script setup>
import { ref } from 'vue'

const viewMode = ref('grid')

definePageMeta({
  layout: 'dashboard'
})

const supabase = useSupabaseClient()

const { data: dashboardData, pending } = await useAsyncData('dashboard-data', async () => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (!session) return { galleries: [], studioName: '' }
  
  const { data, error } = await supabase
    .from('galleries')
    .select('*')
    .eq('user_id', session.user.id)
    .order('created_at', { ascending: false })
    
  if (error) throw error
  return {
    galleries: data || [],
    studioName: session.user.user_metadata?.studio_name || 'Photographer / Studio Name'
  }
}, {
  default: () => ({ galleries: [], studioName: '' })
})
</script>

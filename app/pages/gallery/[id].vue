<template>
  <div v-if="galleryData && !isUnlocked" key="locked" class="bg-gray-50 min-h-screen flex items-center justify-center relative overflow-hidden">
    <!-- Blurred Background Mockup -->
    <img :src="galleryData.coverImage" class="absolute inset-0 w-full h-full object-cover opacity-30 filter blur-2xl scale-125 pointer-events-none" />
    <div class="absolute inset-0 bg-white/70 backdrop-blur-md"></div>
    
    <div class="relative z-10 max-w-md w-full bg-white/90 p-10 rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.12)] border border-white/50 text-center mx-4 backdrop-blur-xl">
       <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-indigo-50 text-indigo-600 mb-6">
         <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
       </div>
       <h1 class="text-3xl font-serif text-gray-900 mb-2 truncate">{{ galleryData.title }}</h1>
       <p class="text-gray-500 mb-8 font-medium">This gallery is uniquely PIN-protected by the photographer.</p>
       
       <form @submit.prevent="verifyPin" class="space-y-4">
         <input v-model="pinInput" type="password" placeholder="Enter PIN" class="text-center w-full px-4 py-4 border border-gray-200 bg-gray-50 rounded-xl mb-2 text-2xl tracking-[0.5em] focus:ring-2 focus:ring-indigo-500 focus:bg-white transition shadow-inner" required />
         <button type="submit" class="w-full bg-gray-900 text-white font-bold py-4 rounded-xl hover:bg-black hover:shadow-lg transition-all transform hover:-translate-y-0.5">Unlock Collection</button>
       </form>
       <p v-if="pinError" class="text-red-500 mt-4 text-sm font-semibold animate-pulse">{{ pinError }}</p>
    </div>
  </div>

  <div v-else-if="galleryData && isUnlocked" key="unlocked-view-isolate">
    <div class="bg-gray-50 min-h-screen w-full block animate-fade-in-up" style="display: block !important;">
      <!-- Hero Header -->
    <header class="relative w-full pt-32 pb-20 flex flex-col items-center overflow-hidden bg-gray-900 shadow-2xl mb-12">
      <img :src="galleryData.coverImage" class="absolute inset-0 w-full h-full object-cover opacity-60 mix-blend-overlay object-center filter blur-sm scale-110" alt="Cover background" />
      <img :src="galleryData.coverImage" class="absolute inset-0 w-full h-full object-cover opacity-80" alt="Cover" />
      <div class="absolute inset-0 bg-gradient-to-b from-gray-900/80 via-gray-900/40 to-transparent"></div>
      
      <div class="relative z-10 text-center px-6 animate-fade-in-up">
        <h1 class="text-5xl md:text-7xl font-serif text-white tracking-wide drop-shadow-2xl mb-4">
          {{ galleryData.title }}
        </h1>
        <p class="text-sm md:text-base text-gray-200 font-medium tracking-[0.3em] uppercase opacity-90">
          {{ galleryData.date }}
        </p>
      </div>
    </header>

    <!-- Main Gallery Area -->
    <section class="max-w-7xl mx-auto px-4 md:px-8 py-16">
      
      <!-- Toolbar -->
      <div class="flex flex-col md:flex-row justify-between items-center mb-12 space-y-4 md:space-y-0">
        <div class="flex flex-wrap justify-center items-center gap-4">
          <div class="flex items-center space-x-2 bg-white rounded-full shadow-sm border border-gray-100 p-1">
            <button @click="filterMode = 'all'" :class="filterMode === 'all' ? 'bg-gray-100 text-gray-900 font-bold' : 'text-gray-500 hover:bg-gray-50'" class="px-5 py-2 rounded-full text-sm transition">All ({{ galleryData.photos.length }})</button>
            <button @click="filterMode = 'favorites'" :class="filterMode === 'favorites' ? 'bg-rose-50 text-rose-600 font-bold' : 'text-gray-500 hover:bg-gray-50'" class="px-5 py-2 rounded-full text-sm transition flex items-center">
              <svg class="w-4 h-4 mr-1.5" :class="filterMode === 'favorites' ? 'fill-current text-rose-500' : 'fill-none stroke-current'" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
              Favorites ({{ selectedPhotos.size }})
            </button>
          </div>
          
          <button v-if="selectedPhotos.size < galleryData.photos.length" @click="selectAllPhotos" class="text-sm font-semibold text-indigo-600 bg-indigo-50/80 hover:bg-indigo-100 px-4 py-2 rounded-full transition whitespace-nowrap">
             Select All
          </button>
          <button v-else @click="clearSelection" class="text-sm font-semibold text-gray-600 bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded-full transition whitespace-nowrap">
             Clear Selection
          </button>
        </div>
        
        <div class="flex flex-col sm:flex-row items-center space-y-3 sm:space-y-0 sm:space-x-4 w-full sm:w-auto z-30">
          
          <!-- Layout Toggles -->
          <div class="hidden md:flex items-center space-x-1 bg-white rounded-xl shadow-sm border border-gray-100 p-1.5 h-[52px]">
            <button @click="layoutMode = 'masonry'" :class="layoutMode === 'masonry' ? 'bg-gray-100 text-gray-900 shadow-inner' : 'text-gray-400 hover:text-gray-700 hover:bg-gray-50'" class="p-2 rounded-lg transition" title="Masonry Layout">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
            </button>
            <button @click="layoutMode = 'grid'" :class="layoutMode === 'grid' ? 'bg-gray-100 text-gray-900 shadow-inner' : 'text-gray-400 hover:text-gray-700 hover:bg-gray-50'" class="p-2 rounded-lg transition" title="Square Grid">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h12a2 2 0 012 2v12a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM4 12h16M12 4v16"></path></svg>
            </button>
            <button @click="layoutMode = 'single'" :class="layoutMode === 'single' ? 'bg-gray-100 text-gray-900 shadow-inner' : 'text-gray-400 hover:text-gray-700 hover:bg-gray-50'" class="p-2 rounded-lg transition" title="Large View">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><rect x="4" y="6" width="16" height="12" rx="2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" /></svg>
            </button>
            <button @click="layoutMode = 'list'" :class="layoutMode === 'list' ? 'bg-gray-100 text-gray-900 shadow-inner' : 'text-gray-400 hover:text-gray-700 hover:bg-gray-50'" class="p-2 rounded-lg transition" title="List View">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 6h12M8 12h12M8 18h12M4 6h.01M4 12h.01M4 18h.01"></path></svg>
            </button>
          </div>
        
        <div class="relative group z-30">
          <button :disabled="isDownloadingAll" class="inline-flex items-center justify-center space-x-2 px-8 py-3 bg-gray-900 text-white rounded-xl shadow-md transition-all duration-300 group-hover:-translate-y-0.5 group-hover:shadow-lg disabled:opacity-50">
            <svg v-if="!isDownloadingAll" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
            <svg v-else class="w-5 h-5 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
            <span class="font-medium tracking-wide">{{ isDownloadingAll ? 'Downloading...' : 'Download' }}</span>
          </button>
          
          <!-- Dropdown Menu (Hover Triggered) -->
          <div class="absolute right-0 top-full pt-2 w-64 invisible opacity-0 group-hover:visible group-hover:opacity-100 transition-all duration-300 transform translate-y-2 group-hover:translate-y-0 pointer-events-none group-hover:pointer-events-auto origin-top-right">
            <div class="bg-white rounded-xl shadow-[0_15px_40px_-5px_rgba(0,0,0,0.15)] border border-gray-100 overflow-hidden py-2">
              <button @click="requestDownload('web-direct')" class="w-full text-left px-5 py-3 hover:bg-gray-50 transition flex flex-col group/btn border-b border-gray-50">
                <span class="text-sm font-semibold text-gray-900 group-hover/btn:text-indigo-600 transition">Web Size</span>
                <span class="text-xs text-gray-500 mt-0.5">Separate files (Optimized)</span>
              </button>
              <button @click="requestDownload('hd-direct')" class="w-full text-left px-5 py-3 hover:bg-gray-50 transition flex flex-col group/btn border-b border-gray-50">
                <span class="text-sm font-semibold text-gray-900 group-hover/btn:text-indigo-600 transition">High Resolution (HD)</span>
                <span class="text-xs text-gray-500 mt-0.5">Separate files (Print Quality)</span>
              </button>
              <button @click="requestDownload('hd-zip')" class="w-full text-left px-5 py-3 hover:bg-indigo-50/50 transition flex flex-col group/btn bg-indigo-50/30">
                <span class="text-sm font-semibold text-indigo-700">Zipped Folder</span>
                <span class="text-xs text-indigo-500/80 mt-0.5">Single .zip file (Recommended)</span>
              </button>
            </div>
          </div>
        </div>
      </div>
      </div>

      <!-- Main Photo Grid Dynamic Subsystem -->
      <div :class="{
        'columns-1 sm:columns-2 lg:columns-3 gap-6 space-y-6': layoutMode === 'masonry',
        'grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-2 md:gap-4': layoutMode === 'grid',
        'flex flex-col space-y-12 items-center max-w-4xl mx-auto': layoutMode === 'single',
        'flex flex-col space-y-4 max-w-5xl mx-auto': layoutMode === 'list'
      }">
        <div v-if="displayedPhotos.length === 0" class="col-span-full py-20 text-center text-gray-400">
          No photos found.
        </div>
        <div 
          v-for="(photo, index) in displayedPhotos" 
          :key="photo.highres" 
          class="relative group overflow-hidden bg-gray-200 cursor-pointer shadow-sm hover:shadow-xl transition-all duration-700 ease-out transform"
          :class="[
             {'break-inside-avoid': layoutMode === 'masonry', 'hover:-translate-y-1': layoutMode !== 'list', 'hover:translate-x-1': layoutMode === 'list'},
             layoutMode === 'single' ? 'rounded-2xl' : 'rounded-lg',
             layoutMode === 'list' ? 'flex flex-row items-center h-24 md:h-32 bg-white ring-1 ring-gray-100' : ''
          ]"
          @click="openLightbox(index)"
        >
          <!-- Auto-adapting Thumbnail Image -->
          <img :src="photo.thumbnail" 
               :class="{
                 'w-full h-auto object-cover': layoutMode === 'masonry',
                 'w-full aspect-square object-cover': layoutMode === 'grid',
                 'w-full h-[60vh] object-contain bg-white/50 p-4 border border-gray-100': layoutMode === 'single',
                 'w-24 md:w-48 h-full object-cover flex-shrink-0': layoutMode === 'list'
               }" 
               class="transform transition-transform duration-700 group-hover:scale-105" loading="lazy" />
               
          <!-- List Mode Only Text Content -->
          <div v-if="layoutMode === 'list'" class="flex-1 px-6 md:px-8 z-10 flex justify-between items-center pointer-events-none">
             <span class="font-medium text-gray-900 truncate pr-4 text-sm md:text-base">{{ photo.filename || 'Photo' }}</span>
             <span class="text-xs text-indigo-600 hidden md:block opacity-0 group-hover:opacity-100 transition-opacity uppercase tracking-wider font-semibold">View &rarr;</span>
          </div>
          
          <!-- Hover Overlay -->
          <div class="absolute inset-0 transition-colors duration-300 flex flex-col justify-between p-4" :class="layoutMode === 'list' ? 'bg-black/0 group-hover:bg-indigo-50/5' : 'bg-black/0 group-hover:bg-black/20'">
            <div :class="layoutMode === 'list' ? 'flex justify-end items-center h-full' : 'flex justify-between items-start'">
              <div v-show="layoutMode !== 'list'" class="opacity-0 group-hover:opacity-100 transition-opacity duration-300 bg-black/40 backdrop-blur-md text-white/90 text-[10px] sm:text-xs font-medium px-3 py-1.5 rounded-full shadow-sm truncate max-w-[65%] tracking-wide">
                {{ photo.filename || 'Photo' }}
              </div>
              <button @click.stop="toggleFavorite(photo.highres)" class="p-2 transition-all transform hover:scale-110 drop-shadow-lg -mt-1 -mr-1" :class="[selectedPhotos.has(photo.highres) ? 'opacity-100' : 'opacity-0 group-hover:opacity-100', layoutMode === 'list' ? 'text-gray-300 hover:text-rose-500' : 'text-white hover:text-rose-100']">
                <svg class="w-8 h-8 filter drop-shadow-md" :class="selectedPhotos.has(photo.highres) ? 'fill-current text-rose-500 stroke-rose-600' : 'fill-current stroke-current'" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
              </button>
            </div>
            
            <div v-show="layoutMode !== 'list'" class="flex items-end justify-center">
              <button class="opacity-0 group-hover:opacity-100 transition-opacity duration-300 transform translate-y-4 group-hover:translate-y-0 bg-white/90 text-gray-900 p-3 rounded-full shadow-lg hover:bg-white mb-4">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Fullscreen Lightbox -->
    <Teleport to="body">
      <div v-if="activePhotoIndex !== null" class="fixed inset-0 z-50 flex items-center justify-center bg-black/95 backdrop-blur-sm transition-opacity" @keydown.esc="closeLightbox">
        
        <!-- Lightbox Info Header -->
        <div class="absolute top-0 left-0 p-6 md:p-8 z-[60]">
          <span class="text-white/60 tracking-[0.15em] uppercase text-xs md:text-sm font-medium drop-shadow-md">
            {{ displayedPhotos[activePhotoIndex].filename || 'Photo' }}
          </span>
        </div>

        <!-- Photographer Controls (Pro Mod) -->
        <div v-if="photographerMode" class="absolute bottom-6 md:bottom-12 flex space-x-8 z-[60] bg-black/50 backdrop-blur-xl px-8 py-4 rounded-full border border-white/10 shadow-2xl">
          <button @click.stop="setAsCover(activePhotoIndex)" class="text-white/70 hover:text-amber-400 transition group flex flex-col items-center">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            <span class="text-[10px] mt-1.5 uppercase font-semibold tracking-widest transition">Set Cover</span>
          </button>
          <button @click.stop="deletePhoto(activePhotoIndex)" class="text-white/70 hover:text-rose-500 transition group flex flex-col items-center">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
            <span class="text-[10px] mt-1.5 uppercase font-semibold tracking-widest transition">Delete</span>
          </button>
        </div>

        <!-- Lightbox Controls -->
        <div class="absolute top-0 right-0 p-6 flex space-x-6 z-50">
          <button @click.stop="downloadSingle(activePhotoIndex)" class="text-white/70 hover:text-white transition group flex flex-col items-center">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
            <span class="text-xs mt-1 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition">Save</span>
          </button>
          <button @click.stop="closeLightbox" class="text-white/70 hover:text-white transition group flex flex-col items-center">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M6 18L18 6M6 6l12 12"></path></svg>
            <span class="text-xs mt-1 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition">Close</span>
          </button>
        </div>

        <!-- Previous Button -->
        <button v-if="activePhotoIndex > 0" @click.stop="prevPhoto" class="absolute left-4 md:left-10 text-white/50 hover:text-white p-4 transition z-50">
          <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 19l-7-7 7-7"></path></svg>
        </button>

        <!-- Current Image -->
        <img :src="displayedPhotos[activePhotoIndex].highres" class="max-h-[85vh] max-w-[90vw] object-contain shadow-2xl ring-1 ring-white/10" @click.stop />

        <!-- Next Button -->
        <button v-if="activePhotoIndex < displayedPhotos.length - 1" @click.stop="nextPhoto" class="absolute right-4 md:right-10 text-white/50 hover:text-white p-4 transition z-50">
          <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 5l7 7-7 7"></path></svg>
        </button>
      </div>

      <!-- Download Scope Modal -->
      <div v-if="showDownloadModal" class="fixed inset-0 z-[60] flex items-center justify-center bg-gray-900/60 backdrop-blur-sm shadow-2xl p-4 animate-fade-in-up">
        <div class="bg-white rounded-3xl p-8 max-w-md w-full shadow-2xl text-center border border-gray-100">
          <div class="w-16 h-16 bg-indigo-50 text-indigo-600 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path></svg>
          </div>
          <h2 class="text-2xl font-serif text-gray-900 mb-2">Download Selection</h2>
          <p class="text-gray-500 mb-8">You have favorited {{ selectedPhotos.size }} photos. You can choose to download your shortlisted favorites or the entire gallery.</p>
          
          <div class="space-y-3">
            <button @click="executeDownload('favorites')" class="w-full py-4 bg-gray-900 text-white rounded-xl font-medium shadow hover:bg-black transition border border-gray-900 flex justify-center items-center">
               <svg class="w-5 h-5 fill-current text-rose-500 mr-2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"></path></svg>
               Favorites Only ({{ selectedPhotos.size }})
            </button>
            <button @click="executeDownload('all')" class="w-full py-4 bg-white text-gray-700 rounded-xl font-medium shadow-sm hover:bg-gray-50 border border-gray-200 transition">
               All Photos ({{ galleryData.photos.length }})
            </button>
            <button @click="showDownloadModal = false" class="w-full py-3 text-gray-400 font-medium hover:text-gray-600 transition text-sm pt-2">
               Cancel
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
  </div>
</template>

<script setup>
definePageMeta({ layout: 'gallery' })
const headerState = useState('gallery-header')
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import JSZip from 'jszip'

const route = useRoute()
const activePhotoIndex = ref(null)
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const galleryId = route.params.id

// Photographer Administration
const photographerMode = computed(() => {
  return typeof user.value?.id !== 'undefined' && user.value?.id === galleryData.value?.userId;
})
const isModifying = ref(false)

// PIN Validation Logic
const isUnlocked = ref(true)
const pinInput = ref('')
const pinError = ref('')

const verifyPin = () => {
  if (pinInput.value === galleryData.value.clientPin) {
    isUnlocked.value = true
  } else {
    pinError.value = "Incorrect PIN. Please try again."
    setTimeout(() => { pinError.value = '' }, 3000)
  }
}

// Fetch real data from Supabase
const { data: galleryData, pending } = await useAsyncData(`gallery-${galleryId}`, async () => {
  // 1. Fetch Gallery metadata
  const { data: gallery, error: galleryError } = await supabase
    .from('galleries')
    .select('*')
    .eq('id', galleryId)
    .single()

  if (galleryError) throw galleryError

  // 2. Fetch all Photos attached to this gallery
  const { data: photos, error: photosError } = await supabase
    .from('photos')
    .select('*')
    .eq('gallery_id', galleryId)
    .order('created_at', { ascending: true })

  if (photosError) throw photosError

  let activeUserStudioName = null
  const { data: sessionData } = await supabase.auth.getSession()
  if (sessionData?.session?.user?.user_metadata?.studio_name) {
    activeUserStudioName = sessionData.session.user.user_metadata.studio_name
  }

  const finalStudioName = gallery.studio_name || activeUserStudioName || 'Studio Name'
  headerState.value = `EasyUpload | ${finalStudioName}`

  if (gallery.client_pin) {
    isUnlocked.value = false
  }

  return {
    userId: gallery.user_id,
    title: gallery.title,
    date: gallery.event_date ? new Date(gallery.event_date).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' }) : 'New Gallery',
    photographer: gallery.studio_name || 'EasyUpload Photographer',
    coverImage: gallery.cover_image_url || 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?auto=format&fit=crop&q=80&w=2600',
    clientPin: gallery.client_pin,
    photos: photos.map(p => ({
      id: p.id,
      storagePath: p.storage_path,
      thumbnail: p.thumbnail_url,
      highres: p.highres_url,
      filename: p.filename
    }))
  }
})

// Photographer Management Methods
const deletePhoto = async (index) => {
  const photo = displayedPhotos.value[index]
  const confirmed = confirm(`Are you sure you want to permanently delete "${photo.filename}"? This literally removes it from the server definitively.`)
  if (!confirmed) return
  
  isModifying.value = true
  try {
    // Drop from Postgres
    const { error: dbError } = await supabase.from('photos').delete().eq('id', photo.id)
    if (dbError) throw dbError
    
    // Purge heavily optimized formats logically by path derivation from the db High-Res trace
    const hdPath = photo.storagePath
    let purgePaths = [hdPath]
    if (hdPath.endsWith('_hd.webp')) {
      purgePaths.push(hdPath.replace('_hd.webp', '_thumb.webp'))
    } else if (hdPath.includes('_original.')) {
      purgePaths.push(hdPath.replace(/_original\.[^/.]+$/, '_thumb.webp'))
    }
    
    await supabase.storage.from('portfolios').remove(purgePaths)

    // Clear reactively from display state safely
    if (galleryData.value?.photos) {
      galleryData.value.photos = galleryData.value.photos.filter(p => p.id !== photo.id)
    }
    selectedPhotos.value.delete(photo.highres)
    
    // Manage lightbox closure logic
    if (galleryData.value.photos.length === 0) {
       closeLightbox()
    } else if (activePhotoIndex.value >= galleryData.value.photos.length) {
       activePhotoIndex.value = galleryData.value.photos.length - 1
    }
  } catch (error) {
     console.error("Failed terminating photo structure:", error)
     alert("Failed to delete this photo payload.")
  } finally {
    isModifying.value = false
  }
}

const setAsCover = async (index) => {
  const photo = displayedPhotos.value[index]
  const confirmed = confirm(`Set "${photo.filename}" as the active cover hero image for this gallery?`)
  if (!confirmed) return
  
  isModifying.value = true
  try {
    const { error } = await supabase.from('galleries').update({ cover_image_url: photo.highres }).eq('id', galleryId)
    if (error) throw error
    
    // Assign locally for dynamic refresh
    galleryData.value.coverImage = photo.highres
    alert("Cover successfully pinned.")
  } catch (error) {
     console.error("Cover update fault:", error)
     alert("Failed overriding the gallery cover artifact.")
  } finally {
    isModifying.value = false
  }
}

// Lightbox Logic
const openLightbox = (index) => {
  activePhotoIndex.value = index
  document.body.style.overflow = 'hidden' // Prevent background scrolling
}

const closeLightbox = () => {
  activePhotoIndex.value = null
  document.body.style.overflow = ''
}

const prevPhoto = () => {
  if (activePhotoIndex.value > 0) activePhotoIndex.value--
}

const nextPhoto = () => {
  if (activePhotoIndex.value < displayedPhotos.value.length - 1) activePhotoIndex.value++
}

// Favoriting & Filtering Logic
const selectedPhotos = ref(new Set())
const filterMode = ref('all')
const layoutMode = ref('masonry')

const toggleFavorite = (photoUrl) => {
  if (selectedPhotos.value.has(photoUrl)) {
    selectedPhotos.value.delete(photoUrl)
  } else {
    selectedPhotos.value.add(photoUrl)
  }
}

const selectAllPhotos = () => {
  if (galleryData.value?.photos) {
    galleryData.value.photos.forEach(p => selectedPhotos.value.add(p.highres))
  }
}

const clearSelection = () => {
  selectedPhotos.value.clear()
}

const displayedPhotos = computed(() => {
  if (!galleryData.value?.photos) return []
  if (filterMode.value === 'favorites') {
    return galleryData.value.photos.filter(p => selectedPhotos.value.has(p.highres))
  }
  return galleryData.value.photos
})

const isDownloadingAll = ref(false)
const showDownloadModal = ref(false)
const pendingDownloadFormat = ref(null)

const requestDownload = (format) => {
  if (selectedPhotos.value.size > 0 && selectedPhotos.value.size < galleryData.value.photos.length) {
    pendingDownloadFormat.value = format
    showDownloadModal.value = true
  } else {
    pendingDownloadFormat.value = format
    executeDownload('all')
  }
}

const executeDownload = async (scope) => {
  showDownloadModal.value = false
  const targetArray = scope === 'favorites' 
    ? galleryData.value.photos.filter(p => selectedPhotos.value.has(p.highres)) 
    : galleryData.value.photos;
    
  const format = pendingDownloadFormat.value;
  
  if (format === 'hd-zip') {
     await downloadFullGallery('hd', targetArray, scope)
  } else if (format === 'web-direct') {
     await downloadMultipleDirect('web', targetArray, scope)
  } else if (format === 'hd-direct') {
     await downloadMultipleDirect('hd', targetArray, scope)
  }
}

const triggerSecureDownload = async (photoUrl, fallbackName) => {
  try {
    const res = await fetch(photoUrl)
    const blob = await res.blob()
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = fallbackName || `easyupload_photo.jpg`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    window.URL.revokeObjectURL(url)
  } catch (error) {
     console.error("Download failed:", error)
     alert("Failed to download image from the secured server.")
  }
}

const downloadSingle = async (index) => {
  const photo = displayedPhotos.value[index]
  await triggerSecureDownload(photo.highres, photo.filename)
}

const downloadMultipleDirect = async (mode, targetArray, scope) => {
  if (!targetArray.length) return alert("No photos currently populated to download.")
  
  const qualityName = mode === 'hd' ? 'High-resolution HD' : 'Web-Optimized'
  const filterSummary = scope === 'favorites' ? 'favorited ' : ''
  const confirmed = confirm(`You are about to prompt your browser to individually download ${targetArray.length} ${filterSummary}${qualityName} photos natively. This may pop up multiple times depending on browser settings. Proceed?`)
  if (!confirmed) return
  
  isDownloadingAll.value = true
  
  for (let i = 0; i < targetArray.length; i++) {
    const photo = targetArray[i];
    const targetUrl = mode === 'hd' ? photo.highres : photo.thumbnail;
    const fileSuffix = mode === 'hd' ? '_HD' : '_Web';
    
    // Inject suffix into filename cleanly
    let filename = photo.filename || `easyupload_photo_${i}.jpg`;
    const parts = filename.split('.');
    if (parts.length > 1) {
      const ext = parts.pop();
      filename = `${parts.join('.')}${fileSuffix}.${ext}`;
    } else {
      filename = `${filename}${fileSuffix}.jpg`;
    }

    await triggerSecureDownload(targetUrl, filename)
    // Add a synthetic delay natively to aggressively prevent browser sequential download spam blockers
    await new Promise(r => setTimeout(r, 600))
  }
  
  isDownloadingAll.value = false
}

const downloadFullGallery = async (mode, targetArray, scope) => {
  if (!targetArray.length) return alert("No photos currently populated to download.")
  
  const qualityName = mode === 'hd' ? 'High-resolution HD' : 'Web-Optimized'
  const filterSummary = scope === 'favorites' ? 'favorited ' : ''
  const confirmed = confirm(`You are about to securely package ${targetArray.length} ${filterSummary}${qualityName} photos into a single ZIP file. This may take a moment depending on your network. Proceed?`)
  if (!confirmed) return
  
  isDownloadingAll.value = true
  
  try {
    const zip = new JSZip()
    const folderName = `${galleryData.value.title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}_${mode}`
    const imgFolder = zip.folder(folderName)

    for (let i = 0; i < targetArray.length; i++) {
      const photo = targetArray[i];
      const targetUrl = mode === 'hd' ? photo.highres : photo.thumbnail;
      const fileSuffix = mode === 'hd' ? '_HD' : '_Web';
      
      // Inject suffix into filename cleanly
      let filename = photo.filename || `easyupload_photo_${i}.jpg`;
      const parts = filename.split('.');
      if (parts.length > 1) {
        const ext = parts.pop();
        filename = `${parts.join('.')}${fileSuffix}.${ext}`;
      } else {
        filename = `${filename}${fileSuffix}.jpg`;
      }

      // Fetch the file as a Blob to compile into the ZIP securely
      const res = await fetch(targetUrl)
      const blob = await res.blob()
      
      imgFolder.file(filename, blob)
      
      // Small delay to prevent browser fetch throttling
      await new Promise(r => setTimeout(r, 200))
    }

    // Generate the compiled ZIP blob memory array
    const content = await zip.generateAsync({ type: 'blob' })
    const zipUrl = window.URL.createObjectURL(content)
    
    // Trigger singular file download
    const a = document.createElement('a')
    a.href = zipUrl
    a.download = `${folderName}.zip`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    window.URL.revokeObjectURL(zipUrl)
    
  } catch (error) {
     console.error("ZIP compilation failed:", error)
     alert("Failed to package ZIP image bundle from the secured server.")
  }
  
  isDownloadingAll.value = false
}

// Global Keyboard Navigation for Lightbox
const handleKeydown = (e) => {
  if (activePhotoIndex.value === null) return
  if (e.key === 'ArrowLeft') prevPhoto()
  if (e.key === 'ArrowRight') nextPhoto()
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})
</script>

<style>
/* Animations for the hero text */
@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fade-in-up {
  animation: fadeInUp 1s ease-out forwards;
}
</style>

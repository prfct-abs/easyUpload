<template>
  <div class="space-y-6 pb-24 max-w-5xl mx-auto">
    
    <div class="flex items-center justify-between pb-4 border-b border-gray-200">
      <div>
        <NuxtLink to="/dashboard" class="inline-flex items-center text-sm font-medium text-gray-500 hover:text-indigo-600 mb-2 transition">
          <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path></svg>
          Back
        </NuxtLink>
        <h1 class="text-3xl font-bold tracking-tight text-gray-900 truncate max-w-full block">
          {{ galleryInfo?.title || 'Gallery' }} <span class="text-gray-300 font-light mx-2">|</span> <span class="text-indigo-600">Upload</span>
        </h1>
        <p class="text-sm text-gray-500 mt-1">Select high-resolution photos to add to this collection.</p>
      </div>
      <button v-if="files.length > 0" @click="startUpload" class="px-6 py-2.5 bg-indigo-600 text-white rounded-lg font-medium shadow-sm hover:bg-indigo-700 transition" :disabled="isUploading">
        <span v-if="isUploading">Uploading...</span>
        <span v-else>Upload {{ files.length }} Files</span>
      </button>
    </div>

    <!-- Drag & Drop Zone -->
    <div 
      class="border-2 border-dashed rounded-2xl p-12 text-center transition-colors"
      :class="isDragging ? 'border-indigo-500 bg-indigo-50' : 'border-gray-300 bg-white hover:bg-gray-50'"
      @dragover.prevent="isDragging = true"
      @dragleave.prevent="isDragging = false"
      @drop.prevent="handleDrop"
    >
      <input type="file" ref="fileInput" multiple accept="image/*" class="hidden" @change="handleFileSelect" />
      
      <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-indigo-100 text-indigo-600 mb-4 cursor-pointer" @click="$refs.fileInput.click()">
        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"></path></svg>
      </div>
      <h3 class="text-lg font-medium text-gray-900">Drag & drop photos here</h3>
      <p class="mt-1 text-sm text-gray-500">or click the icon to browse your device.</p>
      <p class="mt-4 text-xs font-semibold text-gray-400 tracking-wide uppercase">Supports JPG, PNG up to 50MB</p>
    </div>

    <!-- Upload Queue -->
    <div v-if="files.length > 0" class="bg-white rounded-2xl shadow-sm border border-gray-200 overflow-hidden">
      <div class="px-6 py-4 border-b border-gray-100 flex flex-col md:flex-row justify-between items-start md:items-center bg-gray-50 space-y-3 md:space-y-0">
        <h3 class="font-semibold text-gray-900">Upload Queue</h3>
        <div class="flex flex-wrap items-center gap-4 md:space-x-6">
          <input type="text" v-model="watermarkText" placeholder="Watermark text (Optional)..." class="text-sm border-gray-300 rounded-lg px-3 py-1.5 focus:ring-indigo-500 focus:border-indigo-500 w-48 shadow-sm" />
          <label class="flex items-center space-x-2 cursor-pointer group">
            <input type="checkbox" v-model="uploadOriginals" class="form-checkbox h-4 w-4 text-indigo-600 transition duration-150 ease-in-out cursor-pointer rounded border-gray-300 focus:ring-indigo-500" />
            <span class="text-sm text-gray-700 group-hover:text-gray-900 font-medium tracking-tight">Keep Original Files <span class="bg-gradient-to-r from-amber-200 to-yellow-500 text-amber-900 px-2 py-0.5 rounded text-[10px] font-bold uppercase ml-1 shadow-sm">Pro</span></span>
          </label>
          <button @click="clearFiles" class="text-sm text-red-600 font-medium hover:text-red-700">Clear All</button>
        </div>
      </div>
      <ul class="divide-y divide-gray-100 max-h-96 overflow-y-auto">
        <li v-for="(file, index) in files" :key="index" class="p-4 flex items-center justify-between hover:bg-gray-50 transition">
          <div class="flex items-center space-x-4">
            <div class="w-12 h-12 rounded object-cover bg-gray-200 flex items-center justify-center text-xs text-gray-400 overflow-hidden">
               <!-- Mock thumbnail or icon -->
               IMG
            </div>
            <div>
              <p class="text-sm font-medium text-gray-900 truncate w-48 md:w-80">{{ file.name }}</p>
              <p class="text-xs text-gray-500">{{ (file.size / (1024*1024)).toFixed(2) }} MB</p>
            </div>
          </div>
          
          <div class="flex items-center space-x-4">
            <!-- Progress Bar -->
            <div class="w-24 md:w-32 bg-gray-200 rounded-full h-2.5">
              <div class="bg-indigo-600 h-2.5 rounded-full transition-all duration-300" :style="{ width: progress[index] + '%' || '0%' }"></div>
            </div>
            
            <button v-if="!isUploading" @click="removeFile(index)" class="text-gray-400 hover:text-red-500">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
            <div v-else-if="progress[index] === 100" class="text-green-500">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
            </div>
          </div>
        </li>
      </ul>
    </div>
    
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

definePageMeta({
  layout: 'dashboard'
})

const isDragging = ref(false)
const files = ref([])
const progress = ref({})
const isUploading = ref(false)
const uploadOriginals = ref(false)
const watermarkText = ref('')

const router = useRouter()
const route = useRoute()
const supabase = useSupabaseClient()
const user = useSupabaseUser()
const galleryId = route.params.id

const { data: galleryInfo } = await useAsyncData(`gallery-info-${galleryId}`, async () => {
  const { data } = await supabase.from('galleries').select('title').eq('id', galleryId).single()
  return data
})

const handleFileSelect = (event) => {
  addFiles(Array.from(event.target.files))
}

const handleDrop = (event) => {
  isDragging.value = false
  if (event.dataTransfer.files) {
    addFiles(Array.from(event.dataTransfer.files))
  }
}

const addFiles = (newFiles) => {
  newFiles.forEach(file => {
    if (file.type.startsWith('image/')) {
      files.value.push(file)
      progress.value[files.value.length - 1] = 0
    }
  })
}

const removeFile = (index) => {
  files.value.splice(index, 1)
  const newProgress = {}
  files.value.forEach((_, i) => newProgress[i] = 0)
  progress.value = newProgress
}

const clearFiles = () => {
  files.value = []
  progress.value = {}
}

const convertToWebP = (file, maxWidth, quality, isThumb = false, watermark = "") => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(file)
    reader.onload = (event) => {
      const img = new Image()
      img.src = event.target.result
      img.onload = () => {
        let width = img.width
        let height = img.height

        if (width > maxWidth) {
          height = Math.round((maxWidth / width) * height)
          width = maxWidth
        }

        const canvas = document.createElement('canvas')
        canvas.width = width
        canvas.height = height
        const ctx = canvas.getContext('2d')
        ctx.drawImage(img, 0, 0, width, height)

        if (watermark) {
          const fontSize = Math.max(20, Math.floor(width * 0.06))
          ctx.font = `bold ${fontSize}px "SF Pro Display", -apple-system, sans-serif`
          ctx.fillStyle = 'rgba(255, 255, 255, 0.45)'
          ctx.textAlign = 'center'
          ctx.textBaseline = 'middle'
          
          ctx.shadowColor = 'rgba(0, 0, 0, 0.5)'
          ctx.shadowBlur = 15
          ctx.shadowOffsetX = 3
          ctx.shadowOffsetY = 3
          
          ctx.translate(width / 2, height / 2)
          ctx.rotate(-Math.PI / 6) 
          ctx.fillText(watermark, 0, 0)
        }

        canvas.toBlob((blob) => {
          if (!blob) return reject(new Error('Canvas to Blob failed'))
          const newFile = new File([blob], file.name.replace(/\.[^/.]+$/, isThumb ? "_thumb.webp" : ".webp"), {
            type: 'image/webp'
          })
          resolve(newFile)
        }, 'image/webp', quality)
      }
      img.onerror = (e) => reject(e)
    }
    reader.onerror = (e) => reject(e)
  })
}

const startUpload = async () => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (!session) {
    alert("You must be logged in to upload files.")
    return
  }
  
  isUploading.value = true
  
  // Real Supabase Upload Process w/ WebP Dynamic Compression
  const uploadPromises = files.value.map(async (file, index) => {
    try {
      // 1. Convert to high-res logic payload
      let hdFilePayload;
      let hdPath;
      const baseName = `${Math.random().toString(36).substring(2)}_${Date.now()}`
      
      // Pro Option Branch: Preserve original fidelity if checked!
      if (uploadOriginals.value) {
        hdFilePayload = file; 
        const fileExt = file.name.split('.').pop();
        hdPath = `${session.user.id}/${galleryId}/${baseName}_original.${fileExt}`
      } else {
        hdFilePayload = await convertToWebP(file, 2500, 0.85, false, watermarkText.value)
        hdPath = `${session.user.id}/${galleryId}/${baseName}_hd.webp`
      }
      
      // 2. Always convert a highly compressed Thumbnail footprint WebP
      const thumbWebP = await convertToWebP(file, 600, 0.60, true, watermarkText.value)
      const thumbPath = `${session.user.id}/${galleryId}/${baseName}_thumb.webp`

      // 3. Upload both heavily-optimized assets to Supabase Storage
      const { error: hdError } = await supabase.storage.from('portfolios').upload(hdPath, hdFilePayload, { cacheControl: '3600', upsert: false })
      if (hdError) throw hdError

      // Upload the thumbnail footprint concurrently
      const { error: thumbError } = await supabase.storage.from('portfolios').upload(thumbPath, thumbWebP, { cacheControl: '3600', upsert: false })
      if (thumbError) throw thumbError

      // Mark visual progress as complete logically
      progress.value[index] = 100 

      // 4. Retrieve persistent tracking URL definitions
      const { data: hdUrl } = supabase.storage.from('portfolios').getPublicUrl(hdPath)
      const { data: thumbUrl } = supabase.storage.from('portfolios').getPublicUrl(thumbPath)

      // 5. Register the finalized footprint to the Postgres index
      await supabase.from('photos').insert([{
          gallery_id: galleryId,
          storage_path: hdPath,
          filename: file.name,
          size_bytes: hdFilePayload.size + thumbWebP.size,
          highres_url: hdUrl.publicUrl,
          thumbnail_url: thumbUrl.publicUrl 
      }])
      
      return hdUrl.publicUrl
    } catch (err) {
      console.error("Upload error for file:", file.name, err)
      progress.value[index] = 0
      return null
    }
  })

  await Promise.all(uploadPromises)
  
  isUploading.value = false
  // Success! Send photographer to their shiny new live gallery
  router.push(`/gallery/${galleryId}`)
}
</script>

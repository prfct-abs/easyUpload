<template>
  <div class="min-h-screen bg-white text-gray-900 font-sans relative">
    <!-- Gallery Logo (Clean static text, NOT a dashboard menu) -->
    <nav class="absolute top-0 w-full z-10 p-6 flex justify-between items-center bg-gradient-to-b from-black/50 to-transparent pointer-events-none">
      <div class="text-white font-bold tracking-wider uppercase text-sm drop-shadow-md">
        {{ headerState || 'EasyUpload Photographer' }}
      </div>
    </nav>

    <main>
      <slot />
    </main>

    <!-- Simple Footer -->
    <footer class="py-12 text-center text-sm text-gray-500 border-t border-gray-100 mt-20">
      <p>Delivered by EasyUpload</p>
    </footer>
  </div>
</template>

<script setup>
const headerState = useState('gallery-header', () => '')
</script>

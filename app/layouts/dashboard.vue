<template>
  <div class="min-h-screen bg-gray-50 flex flex-col md:flex-row font-sans">
    
    <!-- Mobile Header -->
    <div class="md:hidden bg-white border-b border-gray-200 p-4 flex justify-between items-center sticky top-0 z-20">
      <NuxtLink to="/dashboard" class="text-xl font-bold text-indigo-600">EasyUpload</NuxtLink>
      <button @click="mobileMenuOpen = !mobileMenuOpen" class="text-gray-500 hover:text-gray-700">
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
      </button>
    </div>

    <!-- Sidebar (Desktop & Mobile Slide-out) -->
    <aside :class="['w-64 bg-white border-r border-gray-200 flex-shrink-0 fixed md:sticky top-0 h-screen z-30 transition-transform transform', mobileMenuOpen ? 'translate-x-0' : '-translate-x-full md:translate-x-0']">
      <div class="p-6 hidden md:block">
        <NuxtLink to="/dashboard" class="text-2xl font-bold text-indigo-600 tracking-tight inline-block hover:opacity-80 transition">EasyUpload</NuxtLink>
      </div>
      
      <div class="md:hidden p-4 flex justify-end">
        <button @click="mobileMenuOpen = false" class="text-gray-500">
          <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
        </button>
      </div>

      <nav class="mt-2 px-4 space-y-2">
        <NuxtLink to="/dashboard" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-indigo-600 transition" exact-active-class="bg-indigo-50 text-indigo-700 font-medium">
          <svg class="w-5 h-5 opacity-75" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"></path></svg>
          <span>All Galleries</span>
        </NuxtLink>
        <NuxtLink to="/dashboard/settings" class="flex items-center space-x-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-indigo-600 transition" exact-active-class="bg-indigo-50 text-indigo-700 font-medium">
          <svg class="w-5 h-5 opacity-75" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
          <span>Settings</span>
        </NuxtLink>
      </nav>

      <div class="absolute bottom-0 w-full p-4 border-t border-gray-100">
        <button @click="logout" class="flex items-center space-x-3 px-4 py-3 w-full rounded-lg text-gray-500 hover:bg-red-50 hover:text-red-600 transition">
          <svg class="w-5 h-5 opacity-75" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
          <span>Logout</span>
        </button>
      </div>
    </aside>

    <!-- Overlay for mobile -->
    <div v-if="mobileMenuOpen" @click="mobileMenuOpen = false" class="fixed inset-0 bg-gray-900 bg-opacity-50 z-20 md:hidden"></div>

    <!-- Main Content Area -->
    <main class="flex-1 overflow-x-hidden overflow-y-auto">
      <div class="p-6 md:p-10 max-w-6xl mx-auto">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const mobileMenuOpen = ref(false)
const router = useRouter()

const supabase = useSupabaseClient()

const logout = async () => {
  await supabase.auth.signOut()
  router.push('/login')
}
</script>

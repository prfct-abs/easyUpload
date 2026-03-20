<template>
  <div class="min-h-screen flex flex-col bg-gray-50 text-gray-900 font-sans">
    <nav class="bg-white border-b border-gray-100 flex items-center justify-between px-6 py-4">
      <NuxtLink to="/" class="text-xl font-bold tracking-tight text-indigo-600 hover:opacity-80 transition block">EasyUpload</NuxtLink>
      <div class="space-x-4 text-sm font-medium flex items-center">
        <NuxtLink to="/" class="hover:text-indigo-600 transition tracking-wide text-gray-600 hover:bg-gray-50 px-3 py-1.5 rounded-md">Home</NuxtLink>
        <template v-if="user">
          <NuxtLink to="/dashboard" class="px-5 py-2 bg-indigo-600 text-white shadow-sm font-semibold tracking-wide rounded-md hover:bg-indigo-700 transition">Dashboard &rarr;</NuxtLink>
        </template>
        <template v-else>
          <NuxtLink to="/login" class="px-5 py-2 font-semibold text-gray-700 hover:text-indigo-600 transition">Sign In</NuxtLink>
          <NuxtLink to="/signup" class="px-5 py-2 bg-indigo-600 text-white shadow-sm font-semibold tracking-wide rounded-md hover:bg-indigo-700 transition">Sign Up</NuxtLink>
        </template>
      </div>
    </nav>
    <main class="flex-grow">
      <slot />
    </main>

    <!-- Global Footer -->
    <footer class="bg-white border-t border-gray-100 mt-auto">
      <div class="max-w-7xl mx-auto px-6 py-12 flex flex-col md:flex-row justify-between items-center text-center md:text-left space-y-6 md:space-y-0">
        <div>
          <NuxtLink to="/" class="text-xl font-bold tracking-tight text-gray-900">EasyUpload</NuxtLink>
          <p class="text-sm text-gray-500 mt-1.5 font-medium">Stunning client galleries, drastically simplified.</p>
        </div>
        
        <div class="flex flex-wrap justify-center md:justify-end gap-x-8 gap-y-4 text-sm font-medium text-gray-500">
          <NuxtLink v-if="!user" to="/login" class="hover:text-indigo-600 transition">Photographer Login</NuxtLink>
          <NuxtLink v-if="!user" to="/signup" class="hover:text-indigo-600 transition">Create Account</NuxtLink>
          <a href="#" class="hover:text-indigo-600 transition">Terms of Service</a>
          <a href="#" class="hover:text-indigo-600 transition">Privacy Policy</a>
        </div>
      </div>
      <div class="bg-gray-50 border-t border-gray-100 py-6 text-center">
        <p class="text-xs font-semibold tracking-wider text-gray-400 uppercase">&copy; {{ new Date().getFullYear() }} EasyUpload Platform. All Rights Reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
</script>

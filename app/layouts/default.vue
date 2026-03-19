<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 font-sans">
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
    <main>
      <slot />
    </main>
  </div>
</template>

<script setup>
const user = useSupabaseUser()
</script>

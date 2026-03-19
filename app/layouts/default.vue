<template>
  <div class="min-h-screen bg-gray-50 text-gray-900 font-sans">
    <nav class="bg-white border-b border-gray-100 flex items-center justify-between px-6 py-4">
      <div class="text-xl font-bold tracking-tight text-indigo-600">EasyUpload</div>
      <div class="space-x-4 text-sm font-medium">
        <NuxtLink to="/" class="hover:text-indigo-600 transition">Home</NuxtLink>
        <NuxtLink to="/login" class="px-4 py-2 bg-indigo-50 text-indigo-700 rounded hover:bg-indigo-100 transition">Dashboard</NuxtLink>
      </div>
    </nav>
    <main>
      <slot />
    </main>
  </div>
</template>

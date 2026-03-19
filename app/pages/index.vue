<template>
  <div class="max-w-4xl mx-auto px-6 py-24 text-center mt-12">
    <h1 class="text-5xl md:text-6xl font-black mb-6 tracking-tight text-gray-900 leading-tight">
      Client Galleries, <br/><span class="text-transparent bg-clip-text bg-gradient-to-r from-indigo-500 to-purple-600">Delivered Instantly.</span>
    </h1>
    <p class="text-xl text-gray-500 mb-10 max-w-2xl mx-auto">
      Upload large photos directly from your phone. Share stunning, lightning-fast galleries with your clients.
    </p>
    <div class="flex items-center justify-center space-x-4">
      <NuxtLink to="/login" class="px-8 py-4 bg-indigo-600 text-white rounded-full font-semibold shadow-lg hover:bg-indigo-700 hover:shadow-xl transition transform hover:-translate-y-0.5">
        Photographer Login
      </NuxtLink>
    </div>

    <!-- Preview Graphic -->
    <div class="mt-20 relative mx-auto max-w-3xl rounded-2xl bg-white shadow-2xl overflow-hidden border border-gray-100">
      <div class="h-8 bg-gray-100 border-b border-gray-200 flex items-center px-4 space-x-2">
        <div class="w-3 h-3 rounded-full bg-red-400"></div>
        <div class="w-3 h-3 rounded-full bg-yellow-400"></div>
        <div class="w-3 h-3 rounded-full bg-green-400"></div>
      </div>
      <div class="p-8 pb-0">
        <div class="grid grid-cols-3 gap-4">
          <div class="aspect-square bg-gray-200 rounded-lg shadow-inner"></div>
          <div class="aspect-square bg-gray-300 rounded-lg shadow-inner"></div>
          <div class="aspect-square bg-gray-200 rounded-lg shadow-inner"></div>
          <div class="aspect-square bg-gray-300 rounded-lg shadow-inner"></div>
          <div class="aspect-square bg-gray-200 rounded-lg shadow-inner"></div>
          <div class="aspect-square bg-gray-300 rounded-lg shadow-inner"></div>
        </div>
        <div class="h-10 bg-gradient-to-t from-white to-transparent -mt-10 relative z-10"></div>
      </div>
    </div>
  </div>
</template>

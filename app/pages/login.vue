<template>
  <div class="max-w-md mx-auto mt-20 p-8 bg-white shadow-xl rounded-2xl border border-gray-100">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">Welcome Back</h1>
    <p class="text-gray-500 mb-8">Sign in to manage your client galleries.</p>

    <div v-if="errorMessage" class="mb-4 bg-red-50 text-red-600 p-3 rounded-lg text-sm border border-red-100">
      {{ errorMessage }}
    </div>

    <form @submit.prevent="login" class="space-y-6">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Email address</label>
        <input v-model="email" type="email" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm" placeholder="you@example.com" required>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
        <input v-model="password" type="password" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm" placeholder="••••••••" required>
      </div>

      <button type="submit" class="w-full py-3 bg-indigo-600 text-white font-semibold rounded-lg shadow-md hover:bg-indigo-700 transition" :disabled="loading">
        <span v-if="loading">Signing in...</span>
        <span v-else>Sign In</span>
      </button>
    </form>
    
    <div class="mt-6 text-center text-sm text-gray-500">
      Don't have an account? <NuxtLink to="/signup" class="text-indigo-600 font-semibold hover:underline">Sign up</NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const router = useRouter()

// Get standard Nuxt Supabase client
const supabase = useSupabaseClient()

const login = async () => {
  loading.value = true
  errorMessage.value = ''
  
  const { error } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  })

  loading.value = false

  if (error) {
    errorMessage.value = error.message
  } else {
    // Successfully authenticated
    router.push('/dashboard')
  }
}
</script>

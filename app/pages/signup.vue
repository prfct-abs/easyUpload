<template>
  <div class="max-w-md mx-auto mt-20 p-8 bg-white shadow-xl rounded-2xl border border-gray-100">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">Create Account</h1>
    <p class="text-gray-500 mb-8">Sign up to create your first client gallery.</p>

    <div v-if="successMessage" class="mb-4 bg-green-50 text-green-700 p-3 rounded-lg text-sm border border-green-100">
      {{ successMessage }}
    </div>
    <div v-if="errorMessage" class="mb-4 bg-red-50 text-red-600 p-3 rounded-lg text-sm border border-red-100">
      {{ errorMessage }}
    </div>

    <form @submit.prevent="signup" class="space-y-5" v-if="!successMessage">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Studio / Photographer Name</label>
        <input v-model="studioName" type="text" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm bg-gray-50" placeholder="Jane Doe Photography" required>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Email address</label>
        <input v-model="email" type="email" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm" placeholder="you@example.com" required>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
        <input v-model="password" type="password" minlength="6" class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition shadow-sm" placeholder="••••••••" required>
      </div>

      <button type="submit" class="w-full py-3 bg-indigo-600 text-white font-semibold rounded-lg shadow-md hover:bg-indigo-700 transition" :disabled="loading">
        <span v-if="loading">Creating account...</span>
        <span v-else>Sign Up</span>
      </button>
    </form>
    
    <div class="mt-6 text-center text-sm text-gray-500">
      Already have an account? <NuxtLink to="/login" class="text-indigo-600 font-semibold hover:underline">Log in</NuxtLink>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const studioName = ref('')
const email = ref('')
const password = ref('')
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const router = useRouter()

const supabase = useSupabaseClient()

const signup = async () => {
  loading.value = true
  errorMessage.value = ''
  successMessage.value = ''
  
  const { data, error } = await supabase.auth.signUp({
    email: email.value,
    password: password.value,
    options: {
      data: {
        studio_name: studioName.value
      }
    }
  })

  loading.value = false

  if (error) {
    errorMessage.value = error.message
  } else if (data.session) {
     // User signed in automatically (if auto-confirm is on)
     router.push('/dashboard')
  } else {
    // Requires email confirmation
    successMessage.value = "Registration successful! Please check your email to verify your account before logging in."
  }
}
</script>

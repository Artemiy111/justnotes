<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'

type Note = {
  id: number
  title: string
  done: boolean
}

const status = ref<'idle' | 'loading' | 'error'>('loading')
const notes = ref<Note[]>([])

const fetchNotes = async () => {
  try {
    const localNotesString = localStorage.getItem('notes')
    if (localNotesString) {
      const localNotes = JSON.parse(localNotesString) as Note[]
      notes.value = localNotes
      console.log(localNotes)
      status.value = 'idle'
      return
    }

    const res = await fetch('/tasks.json')
    const data = (await res.json()) as Note[]
    notes.value = data
    status.value = 'idle'
  } catch (error) {
    console.error('Ooops')
    status.value = 'error'
  }
}

onMounted(() => {
  fetchNotes()
})

watch(
  notes,
  () => {
    console.log(notes.value)
    localStorage.setItem('notes', JSON.stringify(notes.value))
  },
  { deep: true },
)
</script>

<template>
  <main class="mx-auto w-md mt-10">
    <h1 class="font-bold text-3xl">Justnotes</h1>
    <div v-if="status === 'loading'" class="mt-8">Loading...</div>
    <div v-if="status === 'error'" class="mt-8 text-red-500">Error</div>
    <ul class="flex flex-col gap-4 mt-8">
      <li v-for="note in notes" :key="note.id">
        {{ note.title }}
        <button class="cursor-pointer" @click="note.done = !note.done">
          {{ note.done ? '✅' : '❌' }}
        </button>
      </li>
    </ul>
  </main>
</template>

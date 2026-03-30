<script setup lang="ts">
import { reactive, ref } from 'vue'
import { Sidebar } from 'frappe-ui'
import { Breadcrumbs } from 'frappe-ui'
import { MultiSelect } from 'frappe-ui'
import { DatePicker } from 'frappe-ui'
import { Dialog } from "frappe-ui"
import { Badge } from "frappe-ui"
import { createResource } from 'frappe-ui'

import Home from '~icons/lucide/home';
import Settings from '~icons/lucide/settings';
import Moon from '~icons/lucide/moon';
import User from '~icons/lucide/user';
import Palette from "~icons/lucide/palette";
import BookOpen from "~icons/lucide/BookOpen";
import Learn from "~icons/lucide/graduation-cap";

const localDate = new Date().toLocaleDateString();
const value = ref(localDate)

const options = [
  { value: "helpful", label: "Helpful" },
  { value: "useful", label: "Useful" },
  { value: "amazing", label: "Amazing" }
];
const state = ref(['amazing']);
const open = ref(false)
const publisher = "$app_publisher";
const appName = "$app_name";
function toggleTheme() {
  const currentTheme = document.documentElement.getAttribute('data-theme')
  const newTheme = currentTheme === 'dark' ? 'light' : 'dark'
  document.documentElement.setAttribute('data-theme', newTheme)
}

const ping = createResource({ url: 'ping' })
const crmSidebar = reactive({
  header: {
    title: 'Frappe UI',
    subtitle: 'Jane Doe',
    logo: 'https://github.com/user-attachments/assets/0a81cdc1-d957-47a9-b151-f5571be0d038',
    menuItems: [
      { label: 'Toggle Theme', icon: Moon, onClick: toggleTheme },
      {
        label: 'Help',
        to: '/help',
        icon: Settings,
        onClick: () => alert('Help clicked!'),
      },
      {
        label: 'Logout',
        to: '/logout',
        icon: User,
        onClick: () => alert('Logging out...'),
      },
    ],
  },
  sections: [
    {
      label: '',
      items: [
        { label: 'Home', icon: Home, to: '/',  },
        { label: "Documentation", icon: BookOpen,  to: "Docs" },
        { label: "Design", icon: Palette, to: "Design" },
        {label: "Learn", icon: Learn, to: "Learn"}
      ],
    }
  ],

})
</script>

<template>
  <div class="h-screen flex">
      <Sidebar :header="crmSidebar.header" :sections="crmSidebar.sections" />
      <div class="flex flex-col w-full">
          <nav class="bg-surface-white border-b px-5 py-2.5 h-12 flex justify-between w-full">
          <Breadcrumbs
            :items="[
              { label: 'Home', route: { name: 'Home' } },
            ]"
          />
            <Button @click="open = true" variant="solid">Test Connection</Button>
        </nav>
        <div class="body-container bg-surface-white h-full pt-10 pb-40" style="margin-left: auto; margin-right: auto">
          <div class="text-2xl font-semibold text-ink-gray-8"> Hello {{ publisher }}</div>
          <div class="mt-4">
              <p> Welcome to Frappe UI! </p>
              <p> Frappe UI is our next generation UI Library. </p>
              <p> It implements our design system called <a href=""> Espresso </a></p>

              <br>
              <div class="flex gap-2 items-center"> 
                <p>Your app <b>{{ appName }}</b> is </p>
                  <MultiSelect
                    :options="options"
                    v-model="state"
                    placeholder="Select fruit"
                /> 
              </div>
              <div class="flex mt-2 gap-2"> 
                Today <DatePicker v-model="value" placeholder="Select Date" label="Label" /> is beautiful.
              </div>


          </div>
        </div>
      </div>
  </div>

    <Dialog v-model="open">
    <template #body-title>
      <h3 class="text-2xl font-semibold">
       Backend Connectivity
      </h3>
    </template>

    <template #body-content>
      <div class="space-y-4">
          <div class="flex gap-2 items-center">
            <p> Status </p>
            <Badge v-if="!ping.data" theme="red" size='md'>Not Connected</Badge>
            <Badge v-else theme="green" size='md'>Connected</Badge>
          </div>
      </div>
    </template>

    <template #actions="{ close }">
      <div class="flex flex-row-reverse gap-2">
        <Button variant="solid" @click="ping.fetch" :loading="ping.loading">
            Connect
        </Button>
        <Button variant="outline" @click="close">Cancel</Button>
      </div>
    </template>
  </Dialog>

    <div class="mx-auto max-w-3xl px-6 py-8">
    <div class="mb-6 flex items-center justify-between">
      <h1 class="text-2xl font-semibold text-ink-gray-9">ToDos</h1>
      <Button variant="solid" @click="showNewDialog = true">
        <template #prefix>
          <LucidePlus class="h-4 w-4" />
        </template>
        New ToDo
      </Button>
    </div>

    <div v-if="todos.data?.length" class="space-y-2">
      <router-link
        v-for="todo in todos.data"
        :key="todo.name"
        :to="{ name: 'TodoDetail', params: { id: todo.name } }"
        class="flex items-center justify-between rounded-lg border bg-surface-white px-4 py-3 transition hover:bg-surface-gray-1"
      >
        <div class="flex items-center gap-3">
          <button
            class="flex h-5 w-5 items-center justify-center rounded border transition"
            :class="[
              todo.status === 'Closed'
                ? 'border-green-600 bg-green-600'
                : 'border-outline-gray-3 hover:border-outline-gray-5',
            ]"
            @click.prevent="toggleStatus(todo)"
          >
            <LucideCheck v-if="todo.status === 'Closed'" class="h-3.5 w-3.5 text-white" />
          </button>
          <span
            class="text-sm"
            :class="[
              todo.status === 'Closed'
                ? 'text-ink-gray-5 line-through'
                : 'text-ink-gray-9',
            ]"
          >
            {% raw %}{{ todo.description || 'Untitled' }}{% endraw %}
          </span>
        </div>
        <div class="flex items-center gap-2">
          <Badge
            v-if="todo.priority"
            :variant="'subtle'"
            :theme="priorityColor(todo.priority)"
            size="sm"
          >
            {% raw %}{{ todo.priority }}{% endraw %}
          </Badge>
          <button
            class="rounded p-1 text-ink-gray-5 transition hover:bg-surface-gray-2 hover:text-ink-red-7"
            @click.prevent="deleteTodo(todo.name)"
          >
            <LucideTrash2 class="h-3.5 w-3.5" />
          </button>
        </div>
      </router-link>
    </div>

    <div
      v-else-if="!todos.loading"
      class="flex flex-col items-center justify-center rounded-lg border border-dashed py-12 text-ink-gray-5"
    >
      <LucideListTodo class="mb-3 h-10 w-10 text-ink-gray-4" />
      <p class="text-sm">No ToDos yet. Create one to get started.</p>
    </div>

    <Dialog v-model="showNewDialog" :options="{ title: 'New ToDo' }">
      <template #body-content>
        <div class="space-y-4">
          <FormControl
            label="Description"
            v-model="newTodo.description"
            type="textarea"
            placeholder="What needs to be done?"
          />
          <FormControl
            label="Priority"
            v-model="newTodo.priority"
            type="select"
            :options="['Low', 'Medium', 'High']"
          />
        </div>
      </template>
      <template #actions>
        <Button
          variant="solid"
          class="w-full"
          @click="createTodo"
          :loading="creating"
        >
          Create
        </Button>
      </template>
    </Dialog>
  </div>
</template>

<style>
.body-container{
  margin-left: auto;
  margin-right: auto;
  width: 100%;
  max-width: 940px;
}
</style>
'use client'

import { useState, useEffect } from 'react'

export default function Home() {
  const [count, setCount] = useState(0)
  const [tasks, setTasks] = useState<Array<{ id: number; text: string; done: boolean }>>([
    { id: 1, text: 'Deploy with OpenRun', done: true },
    { id: 2, text: 'Test the deployment', done: false },
    { id: 3, text: 'Add new features', done: false },
  ])
  const [newTask, setNewTask] = useState('')

  const addTask = () => {
    if (newTask.trim()) {
      setTasks([...tasks, { id: Date.now(), text: newTask, done: false }])
      setNewTask('')
    }
  }

  const toggleTask = (id: number) => {
    setTasks(tasks.map(task =>
      task.id === id ? { ...task, done: !task.done } : task
    ))
  }

  const deleteTask = (id: number) => {
    setTasks(tasks.filter(task => task.id !== id))
  }

  return (
    <main className="min-h-screen p-8 bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <header className="text-center mb-12">
          <h1 className="text-5xl font-bold text-gray-900 mb-4">
            Next.js Example App
          </h1>
          <p className="text-xl text-gray-600">
            Deployed with <span className="font-semibold text-indigo-600">OpenRun</span>
          </p>
        </header>

        {/* Counter Demo */}
        <div className="bg-white rounded-lg shadow-lg p-8 mb-8">
          <h2 className="text-2xl font-bold mb-4">Interactive Counter</h2>
          <div className="flex items-center gap-4">
            <button
              onClick={() => setCount(count - 1)}
              className="px-6 py-3 bg-red-500 text-white rounded-lg hover:bg-red-600 transition"
            >
              Decrease
            </button>
            <span className="text-4xl font-bold text-gray-900 min-w-[100px] text-center">
              {count}
            </span>
            <button
              onClick={() => setCount(count + 1)}
              className="px-6 py-3 bg-green-500 text-white rounded-lg hover:bg-green-600 transition"
            >
              Increase
            </button>
            <button
              onClick={() => setCount(0)}
              className="px-6 py-3 bg-gray-500 text-white rounded-lg hover:bg-gray-600 transition"
            >
              Reset
            </button>
          </div>
        </div>

        {/* Todo List Demo */}
        <div className="bg-white rounded-lg shadow-lg p-8">
          <h2 className="text-2xl font-bold mb-6">Task List</h2>

          {/* Add Task */}
          <div className="flex gap-2 mb-6">
            <input
              type="text"
              value={newTask}
              onChange={(e) => setNewTask(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && addTask()}
              placeholder="Add a new task..."
              className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button
              onClick={addTask}
              className="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
            >
              Add
            </button>
          </div>

          {/* Task List */}
          <div className="space-y-2">
            {tasks.map(task => (
              <div
                key={task.id}
                className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition"
              >
                <input
                  type="checkbox"
                  checked={task.done}
                  onChange={() => toggleTask(task.id)}
                  className="w-5 h-5 text-indigo-600 rounded focus:ring-2 focus:ring-indigo-500"
                />
                <span className={`flex-1 ${task.done ? 'line-through text-gray-400' : 'text-gray-900'}`}>
                  {task.text}
                </span>
                <button
                  onClick={() => deleteTask(task.id)}
                  className="px-3 py-1 text-red-600 hover:bg-red-50 rounded transition"
                >
                  Delete
                </button>
              </div>
            ))}
          </div>

          {/* Stats */}
          <div className="mt-6 pt-6 border-t border-gray-200">
            <div className="flex justify-between text-sm text-gray-600">
              <span>Total: {tasks.length}</span>
              <span>Completed: {tasks.filter(t => t.done).length}</span>
              <span>Remaining: {tasks.filter(t => !t.done).length}</span>
            </div>
          </div>
        </div>

        {/* Footer */}
        <footer className="mt-12 text-center text-gray-600">
          <p className="mb-2">
            Built with <strong>Next.js</strong> • Deployed with <strong>OpenRun</strong>
          </p>
          <p className="text-sm">
            Using <a href="https://github.com/HyperDevApp/openrun-claude-plugin" className="text-indigo-600 hover:underline">
              OpenRun Claude Code Plugin
            </a>
          </p>
        </footer>
      </div>
    </main>
  )
}

# 📝 SwiftUI To-Do List App

A simple and elegant To-Do List application built using **SwiftUI**, designed to help users manage tasks efficiently. The app supports adding, updating, deleting, and reordering tasks, all with persistent storage using **UserDefaults**.

## 📱 Features

- ✅ Add new to-do items
- 🧠 Validate input with a character limit
- 📋 View a list of tasks with dynamic UI
- 🟢 Mark tasks as complete/incomplete with a tap
- ❌ Delete and reorder tasks using swipe gestures
- 💾 Local data persistence using `UserDefaults`
- 📉 Empty state with an animated call-to-action

## 🧱 Project Structure

- `ItemModel.swift`: Data model representing each to-do item.
- `ListViewModel.swift`: ViewModel handling logic, data manipulation, and persistence.
- `AddView.swift`: UI to input and add new to-do items.
- `ListView.swift`: Main view showing the list of tasks.
- `ListRowView.swift`: Reusable row view for each item.
- `NoItemsView.swift`: Animated UI for when the task list is empty.

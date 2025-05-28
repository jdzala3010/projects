# 📖 Blog App

A modern blog application built using **SwiftUI** and **Firebase**, designed with the **MVVM architecture pattern**. This app enables users to authenticate, write, view, and manage blogs, with planned enhancements like following systems and notifications.

---

## 🚀 Features

### 🔐 1. User Authentication
- Email & Password Sign Up / Sign In / Logout
- Google Sign-In integration
- Password reset functionality
- User profile setup: `username`, `avatar`, and `bio`

### ✍️ 2. Create & Edit Blog Posts
- Create blogs with `title`, `content`, `tags`, and optional cover image
- Edit existing blog posts

### 📚 3. View Blogs
- **Home Feed**: See latest or trending blog posts of your favourote authers
- **Explore Profiles**: View all blogs by all the authors
- **Add Post View**: Create new blog post
- **Search View**: Search blogs by tags
- **Profile View**: Profile page to show total posts, followers and following

---

## 🛠 Architecture

The app uses **MVVM** (Model-View-ViewModel) architecture:
- `Model`: Blog and Author models are Codable and stored in Firestore.
- `ViewModel`: Handles authentication, blog CRUD, and user session state.
- `View`: SwiftUI views structured with `NavigationStack`, `EnvironmentObject`, and `@StateObject`.

---

## 📦 Tech Stack

- **SwiftUI** – Declarative UI framework
- **Firebase Authentication** – Email/password and Google sign-in
- **Firebase Firestore** – NoSQL database for blogs and user data
- **Firebase Storage** – For storing user avatars and blog cover images (planned)
- **Swift Concurrency (async/await)** – For modern async operations

---

## 🔮 Future Enhancements

### 🔍 6. Search & Filter
- Search blogs by keyword or tag
- Filter by recent or popular

### 📌 7. Bookmarks
- Bookmark blog posts to read later

### 🔔 8. Push Notifications
- Notify users of new posts from followed authors

### 👥 9. User Following System
- Follow/unfollow other authors
- Personalized feed based on followed users

---

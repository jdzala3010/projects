//
//  Blog.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import Foundation

struct Blog: Identifiable, Codable {
    var id: String  // Firestore auto-ID
    var title: String                   // Blog title
    var content: String                 // Markdown or plain text
    var tags: [String]                  // ["Swift", "iOS", "Firebase"]
    var coverImageURL: String?          // Optional cover image
    var authorID: String               // UID of the author
    var authorName: String             // For easy display
    var authorAvatarURL: String?        // Optional avatar
    
    var createdAt: Date                 // Blog creation timestamp
    var updatedAt: Date?                // Last updated
    var status: String? = "draft"                 // "draft" or "published"
    
    var viewsCount: Int = 0               // Total views
    var likesCount: Int = 0               // Total likes
    var bookmarksCount: Int = 0           // Total bookmarks
    
    // Optional fields
    var isFeatured: Bool?               // For trending/home feed logic
}

extension Blog {
    static let mockPosts: [Blog] = [
        Blog(
            id: "1",
            title: "Getting Started with SwiftUI",
            content: "SwiftUI is Apple’s modern way to build UI across all Apple platforms. In this blog, we’ll cover the basics of building layouts, managing state, and more.",
            tags: ["SwiftUI", "iOS", "Beginner"],
            coverImageURL: "https://via.placeholder.com/400x200.png?text=SwiftUI",
            authorID: "user_001",
            authorName: "Jane Developer",
            authorAvatarURL: "https://i.pravatar.cc/150?img=3",
            createdAt: Date(),
            updatedAt: Date(),
            status: "published",
            viewsCount: 10,
            likesCount: 128,
            bookmarksCount: 45,
            isFeatured: true
        ),
        Blog(
            id: "2",
            title: "Using Firebase Firestore in Swift",
            content: "Learn how to integrate Firebase Firestore into your SwiftUI apps, including reading and writing data, authentication, and Firestore rules.",
            tags: ["Firebase", "Backend", "Swift"],
            coverImageURL: nil,
            authorID: "user_002",
            authorName: "John Coder",
            authorAvatarURL: "https://i.pravatar.cc/150?img=5",
            createdAt: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            updatedAt: nil,
            status: "draft",
            viewsCount: 10,
            likesCount: 59,
            bookmarksCount: 22,
            isFeatured: false
        ),
        Blog(
            id: "3",
            title: "Top 10 iOS Development Tools in 2025",
            content: "Here are the top tools every iOS developer should know in 2025, from SwiftLint to Xcode Cloud.",
            tags: ["Tools", "Productivity", "iOS"],
            coverImageURL: "https://via.placeholder.com/400x200.png?text=iOS+Tools",
            authorID: "user_003",
            authorName: "Sara Swift",
            authorAvatarURL: "https://i.pravatar.cc/150?img=7",
            createdAt: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            updatedAt: Date(),
            status: "published",
            viewsCount: 10,
            likesCount: 203,
            bookmarksCount: 89,
            isFeatured: true
        )
    ]
}



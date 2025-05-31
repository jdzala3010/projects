//
//  AddBlogViewModel.swift
//  Blog
//
//  Created by Jaydeep Zala on 23/05/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class AddBlogViewModel: ObservableObject {
    
    @Published var post: Blog?
    
    let shared = AuthService.instance
    
    private let db = Firestore.firestore()
    private let blogCollection = "blogs"
    
    func createPost(title: String, content: String, tags: String) async throws {
        let tags = tags.split(separator: "#").map( {String($0)}).filter({!$0.isEmpty})
        
        let postRef = db.collection(blogCollection).document()
        let postID = postRef.documentID
        
        let post = Blog(id: postID, title: title, content: content, tags: tags,
                        authorID: shared.userSession?.uid ?? "None", authorName: shared.userSession?.displayName ?? "None",
                        createdAt: .now ,status: "published")
        let encodedPost = try Firestore.Encoder().encode(post)
        try? await postRef.setData(encodedPost)
        
        try await db.collection("author").document(shared.userSession!.uid).updateData([
                "blogsCount": FieldValue.increment(Int64(1))
            ])
    }
    
    func fetchPublishedBlogs() async throws -> [Blog] {
        let snapshot = try await db.collection(blogCollection)
            .whereField("status", isEqualTo: "published")
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap({try $0.data(as: Blog.self)})
    }
    
    func fetchBlogs() async throws -> [Blog] {
            let snapshot = try await db.collection(blogCollection)
            .whereField("authorID", isEqualTo: shared.userSession!.uid)
                .order(by: "createdAt", descending: true)
                .getDocuments()
        
            return try snapshot.documents.compactMap { try $0.data(as: Blog.self) }
        }
    
    func deleteBlog(blogID: String) async throws {
        
        try await db.collection(blogCollection).document(blogID).delete()
        
        try await db.collection("author").document(shared.userSession!.uid).updateData([
            "blogsCount": FieldValue.increment(Int64(-1))
        ])
    }
    
    func updatePost(postID: String, newTitle: String, newContent: String) async throws {
        let updatedFields: [String: Any] = [
            "title": newTitle,
            "content": newContent,
            "updatedAt": Date()
        ]
        
        try await db.collection(blogCollection).document(postID).updateData(updatedFields)
    }
    
    func bookmarkBlog(blog: Blog) async throws {
        let bookmarkRef = db.collection("author").document(shared.userSession!.uid).collection("bookmarks").document(blog.id)
        
        try await bookmarkRef.setData(
            ["timestamp" : FieldValue.serverTimestamp()]
        )
    }
    
    func fetchBookmarkedBlogs(userID: String) async throws -> [Blog] {
        let bookmarkSnapshot = try await db.collection("author")
            .document(userID)
            .collection("bookmarks")
            .getDocuments()
        
        let blogIDs = bookmarkSnapshot.documents.map { $0.documentID }
        
        var blogs: [Blog] = []
        
        for blogID in blogIDs {
            let blogDoc = try await db.collection("blogs")
                .document(blogID)
                .getDocument()
            
            let blog = try blogDoc.data(as: Blog.self)
            blogs.append(blog)
        }
        return blogs
    }

}



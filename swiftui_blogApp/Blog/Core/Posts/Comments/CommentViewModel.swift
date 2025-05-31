//
//  CommentViewModel.swift
//  Blog
//
//  Created by Jaydeep Zala on 29/05/25.
//

import Foundation

import FirebaseFirestore

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var newComment: String = ""

    private let db = Firestore.firestore()

    func fetchComments(for blogID: String) async {
        let ref = db.collection("blogs").document(blogID).collection("comments").order(by: "createdAt", descending: false)

        do {
            let snapshot = try await ref.getDocuments()
            self.comments = snapshot.documents.compactMap { doc in
                try? doc.data(as: Comment.self)
            }
        } catch {
            print("Failed to fetch comments: \(error)")
        }
    }

    func postComment(blogID: String, userID: String, username: String) async {
        let comment = Comment(
            id: UUID().uuidString,
            userID: userID,
            username: username,
            content: newComment,
            createdAt: Date()
        )

        do {
            try db.collection("blogs").document(blogID)
                .collection("comments")
                .document(comment.id)
                .setData(from: comment)

            newComment = ""
            await fetchComments(for: blogID)
        } catch {
            print("Failed to post comment: \(error)")
        }
    }
}

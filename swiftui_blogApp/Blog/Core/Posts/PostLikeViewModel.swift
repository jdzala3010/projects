//
//  PostLikeViewModel.swift
//  Blog
//
//  Created by Jaydeep Zala on 29/05/25.
//

import Foundation
import Firebase
import FirebaseFirestore

@MainActor
class PostLikeViewModel: ObservableObject {
    
    @Published var postLiked: Bool?
    
    private let blogCollection = "blogs"
    
    func hasUserLiked(blogID: String, userID: String) async throws {
        let likeDocRef = Firestore.firestore()
            .collection(blogCollection)
            .document(blogID)
            .collection("likes")
            .document(userID)
        
        let doc = try await likeDocRef.getDocument()
        self.postLiked = doc.exists
    }
    
    func likePost(blogID: String, userID: String) async throws {
        let likeDocRef = Firestore.firestore()
            .collection(blogCollection)
            .document(blogID)
            .collection("likes")
            .document(userID)

        try await likeDocRef.setData([:])

        try await Firestore.firestore()
            .collection(blogCollection)
            .document(blogID)
            .updateData(["likesCount": FieldValue.increment(Int64(1))])
    }

    func unlikePost(blogID: String, userID: String) async throws {
        let likeDocRef = Firestore.firestore()
            .collection(blogCollection)
            .document(blogID)
            .collection("likes")
            .document(userID)

        try await likeDocRef.delete()

        try await Firestore.firestore()
            .collection(blogCollection)
            .document(blogID)
            .updateData(["likesCount": FieldValue.increment(Int64(-1))])
    }
}

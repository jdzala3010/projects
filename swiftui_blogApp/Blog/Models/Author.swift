//
//  Author.swift
//  Blogger
//
//  Created by Jaydeep Zala on 21/05/25.
//

import Foundation

struct Author: Identifiable, Codable {
    let id: String
    let name: String
    let username: String
    let email: String
    let bio: String?
    let profileImageURL: URL?
    let followers: Int?
    let following: Int?
    let blogsCount: Int?
    
    init(id: String, name: String, username: String, email: String, bio: String? = nil, profileImageURL: URL? = nil, followers: Int = 0, following: Int = 0, blogsCount: Int = 0) {
        self.id = id
        self.name = name
        self.username = username
        self.bio = bio
        self.email = email
        self.profileImageURL = profileImageURL
        self.followers = followers
        self.following = following
        self.blogsCount = blogsCount
    }
}

extension Author {
    static let mock = Author(
        id: UUID().uuidString,
        name: "Jane Developer",
        username: "janedev",
        email: "totestweb@gmail.com",
        bio: "iOS Developer | Blogger | SwiftUI Enthusiast 🚀",
        profileImageURL: URL(string: "https://example.com/jane.jpg"),
        followers: 1250,
        following: 340,
        blogsCount: 27
    )
}



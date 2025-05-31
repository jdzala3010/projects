//
//  CommentModel.swift
//  Blog
//
//  Created by Jaydeep Zala on 29/05/25.
//

import Foundation

struct Comment: Identifiable, Codable {
    let id: String
    let userID: String
    let username: String
    let content: String
    let createdAt: Date
}

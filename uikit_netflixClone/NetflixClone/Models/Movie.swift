//
//  Movie.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import Foundation

struct TrendingMovies: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let mediaType: String?
    let originalTitle: String?
    let originalName: String?
    let overview: String?
    let posterPath: String?
    let voteCount: Int?
    let releaseDate: String?
    let voteAverage: Double?
}

//
//  Video.swift
//  NetflixClone
//
//  Created by Jaydeep Zala on 11/06/25.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [YouTubeVideo]
}

struct YouTubeVideo: Codable {
    let id: VideoID
}

struct VideoID: Codable {
    let videoId: String
}

//
//  NetworkManager.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 06/05/25.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl: String = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower],GFError>) -> ()) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getUser(for username: String, completion: @escaping (Result<User,GFError>) -> ()) {
        let endpoint = baseUrl + "\(username)"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}

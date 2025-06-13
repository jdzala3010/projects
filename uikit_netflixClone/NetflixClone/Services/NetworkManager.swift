//
//  NetworkManager.swift
//  ToDoApp_UIKit
//
//  Created by Jaydeep Zala on 02/06/25.
//

import Foundation

enum APIError: String, Error {
    case failedAPI = "Failed to fetch API"
}

final class NetworkManager {
    
    static let instace = NetworkManager()
    
    private init() { }
    
    func getTrending(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseAPI)3/trending/movie/day") else {
            return
        }
        
        let request = handleRequst(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let trendingMovies = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(trendingMovies.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseAPI)3/movie/popular") else {
            return
        }
        
        let request = handleRequst(url: url)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let popularMovies = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(popularMovies.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    
    func upcomingMoies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseAPI)3/movie/upcoming") else {
            return
        }
        
        let request = handleRequst(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let upcomingMovies = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(upcomingMovies.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    func topRated(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseAPI)3/movie/top_rated") else {
            return
        }
        
        let request = handleRequst(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let topRated = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(topRated.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    func getSearchedMovies(name: String, completion: @escaping (Result<[Movie], APIError>) -> ()) {
        
        guard let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url = URL(string: "\(Constants.baseAPI)3/search/movie?query=\(query)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(Constants.APIToken)"
        ]
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let discoveredMovies = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(discoveredMovies.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    func getDiscoveredMovies(completion: @escaping (Result<[Movie], APIError>) -> ()) {
        guard let url = URL(string: "\(Constants.baseAPI)3/discover/movie") else {
            return
        }
        
        let request = handleRequst(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let topRated = try decoder.decode(TrendingMovies.self, from: data)
                return completion(.success(topRated.results))
            } catch {
                return completion(.failure(APIError.failedAPI))
            }
        }.resume()
    }
    
    private func handleRequst(url: URL) -> URLRequest{
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        components.queryItems = [
                URLQueryItem(name: "language", value: "en-US"),
            ]
        
        guard let finalURL = components.url else {
               fatalError("Invalid URL with query items")
        }

        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(Constants.APIToken)",
          "User-Agent": "Mozilla/5.0"
        ]

        return request
    }
    
    func getVideoID(query: String, completion: @escaping (Result<String, APIError>) -> ()) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
//        https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=harry%20potter&key=[YOUR_API_KEY]
        guard let url = URL(string: "\(Constants.YTbaseAPI)?part=snippet&q=\(query)&key=\(Constants.GoogleAPI_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data,
                  error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                completion(.success(result.items.first!.id.videoId))
            } catch {
                completion(.failure(.failedAPI))
            }
        }.resume()
    }
    
    func getMovieURL(videoID: String) -> URL? {
        
//        https://www.youtube.com/embed/\(videoID)
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return nil}
        return url
    }
}

//
//  PersistenceManager.swift
//  GH Followers
//
//  Created by Jaydeep Zala on 09/05/25.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping (GFError?) -> ()) {

        retrieveFavorites { result in
            
            switch result {
                case .success(let followers):
                    var retrivedFavorites = followers
                    
                    switch actionType {
                        case .add:
                            if followers.contains(favorite) {
                                completion(.alreadyFavourated)
                                return
                            }
                            retrivedFavorites.append(favorite)
                            
                        case .remove:
                            guard let index = retrivedFavorites.firstIndex(where: { $0.login == favorite.login }) else {
                                completion(.errorRemoving)
                                return
                            }
                            retrivedFavorites.remove(at: index)
                    }
                    completion(save(favourites: retrivedFavorites))
                    
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Follower], GFError>) -> ()) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(followers))
        } catch {
            completion(.failure(.unableFavoriting))
        }
    }
    
    static private func save(favourites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let followers = try encoder.encode(favourites)
            defaults.set(followers, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToComplete
        }
    }
}

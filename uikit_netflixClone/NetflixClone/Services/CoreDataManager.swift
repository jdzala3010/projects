//
//  CoreDataManager.swift
//  NetflixClone
//
//  Created by Jaydeep Zala on 12/06/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func createMovie(_ movie: Movie) {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(movie.id)
        movieEntity.mediaType = movie.mediaType
        movieEntity.originalTitle = movie.originalTitle
        movieEntity.originalName = movie.originalName
        movieEntity.overview = movie.overview
        movieEntity.posterPath = movie.posterPath
        movieEntity.voteCount = Int64(movie.voteCount ?? 0)
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.voteAverage = movie.voteAverage ?? 0.0
        save()
    }
    
    func fetchMovies() -> [MovieEntity] {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Fetch failed: \(error)")
            return []
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movie.id)

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()

        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Save failed: \(error)")
        }
    }
}


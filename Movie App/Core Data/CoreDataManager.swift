//
//  CoreDataManager.swift
//  Movie App
//
//  Created by Еркебулан on 18.05.2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func save() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func allMovies() -> [TrendingMoviesEntity.Movie] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        
        let movies = try? context.fetch(request)
        
        return movies?.map( { TrendingMoviesEntity.Movie(movie: $0) } ) ?? []
    }
    
    func addMovie(_ movie: TrendingMoviesEntity.Movie) {
        let context = persistentContainer.viewContext
        
        context.perform {
            let newMovie = MovieEntity(context: context)
            newMovie.id = Int64(movie.id)
            newMovie.title = movie.title
        }
        save()
    }
    
    func addMovie(_ movie: MovieDetailsEntity) {
        let context = persistentContainer.viewContext
        if let id = movie.id {
            context.perform {
                let newMovie = MovieEntity(context: context)
                newMovie.id = Int64(id)
                newMovie.title = movie.title
            }
        }
        save()
    }
    
    func deleteMovie(with id: Int) {
        let context = persistentContainer.viewContext
        if let movie = MovieEntity.findMovie(with: id, context: context) {
            context.delete(movie)
        }
        save()
    }
    
}

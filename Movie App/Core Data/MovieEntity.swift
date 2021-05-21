//
//  MoviesEntity.swift
//  Movie App
//
//  Created by Еркебулан on 18.05.2021.
//

import Foundation
import CoreData

class MovieEntity: NSManagedObject {
    static func findMovie(with id: Int, context: NSManagedObjectContext) -> MovieEntity? {
        let requestResult: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        requestResult.predicate = NSPredicate(format: "id == %d", id)
        do {
            let movies = try context.fetch(requestResult)
            if movies.count > 0 {
                assert(movies.count == 1, "Duplicate found!!!")
                
                return movies[0]
            }
            
        } catch {
            print(error)
        }
        
        return nil
    }
}

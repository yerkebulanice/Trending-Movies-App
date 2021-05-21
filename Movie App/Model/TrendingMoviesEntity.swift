//
//  MovieEntity.swift
//  Movie App
//
//  Created by Еркебулан on 22.04.2021.
//

import Foundation

struct TrendingMoviesEntity: Decodable {
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
    struct Movie: Decodable {
        let id: Int
        let poster: String?
        let title: String?
        let releaseDate: String?
        let rating: Double?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case poster = "poster_path"
            case title = "original_title"
            case releaseDate = "release_date"
            case rating = "vote_average"
        }
        
        init(movie: MovieEntity) {
            self.id = Int(movie.id)
            self.title = movie.title
            self.poster = movie.poster
            self.releaseDate = movie.releaseDate
            self.rating = movie.rating
        }
        
    }
    
    
}

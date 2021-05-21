//
//  MovieDetailsEntity.swift
//  Movie App
//
//  Created by Еркебулан on 23.04.2021.
//

import Foundation

struct MovieDetailsEntity: Decodable {
    var id: Int?
    let poster: String?
    let title: String
    let releaseDate: String
    let rating: Double
    let description: String
    enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case title = "original_title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case description = "overview"
    }
}

//1. Page title = Movie Title  -> "original_title"
//2. Movie poster -> "poster_path"
//3. Movie rating on white circle -> "vote_average"
//4. Movie title over poster -> "title"
//5. Release date over poster -> "release_date"
//6. Movie description under poster -> "overview"

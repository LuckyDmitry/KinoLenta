//
//  SearchModel.swift
//  KinoLenta
//
//  Created by Max Nigmatulin on 13.12.2021.
//

import Foundation

struct SearchModel: Decodable {
    let posterPath: String?
    let popularity: Float?
    let id: Int
    let overview: String?
    let backdropPath: String?
    let voteAverage: Int?
    let mediaType: String?
    let firstAirDate: String?
    let originCountry: [String]?
    let genreIDS: [Int]?
    let originalLanguage: String?
    let voteCount: Int?
    let name: String
    let originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id, overview
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
    }
}


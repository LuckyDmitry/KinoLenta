//
//  MovieModel.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 09.12.2021.
//

import Foundation


// MARK: - MovieModel
struct MovieModel: Codable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let backdropPath: URL?
    let video: Bool
    let runtime: Int
    let releaseDate: String

    let originalTitle: String?
    let adult: Bool?
    let budget: Int?
    let homepage: String?
    let imdbID, originalLanguage: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let status, tagline: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


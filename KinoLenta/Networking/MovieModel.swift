//
//  FilmDTO.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 09.12.2021.
//

import Foundation


// MARK: - MovieModel
struct MovieModel: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let genres: [Genre]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let backdropPath: String
    let video: Bool
    let revenue, runtime: Int
    let releaseDate: String

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
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

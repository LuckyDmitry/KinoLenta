//
//  MovieModel.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 09.12.2021.
//

import Foundation

struct QueryMovieModel: Decodable {
    let posterPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    let genreIDS: [Int]?
    let id: Int
    let originalTitle: String?
    let originalLanguage: OriginalLanguage?
    let title: String
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return Endpoint.smallImage(path: backdropPath)
    }

    var parsedDate: Date? {
        parseDate(date: releaseDate)
    }

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
}

enum OriginalLanguage: String, Decodable {
    case en = "en"
}

// MARK: - MovieModel

struct MovieModel: Decodable {
    let id: Int
    let title: String
    let overview: String
    let genres: [Genre]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let backdropURL: URL?
    let video: Bool
    let runtime: Int
    let releaseDate: String

    let originalTitle: String?
    let adult: Bool?
    let budget: Int?
    let homepage: String?
    let imdbID: String?
    let originalLanguage: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let status: String?
    let tagline: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropURL = "backdrop_path"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case runtime
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


//
//  NetworkItemModel.swift
//  KinoLenta
//
//  Created by Max Nigmatulin on 11.12.2021.
//

import Foundation


// MARK: - MovieDomainModel

struct MovieDomainModel: Codable, Hashable {
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return Endpoint.smallImage(path: backdropPath)
    }

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return Endpoint.smallImage(path: posterPath)
    }

    var parsedDate: Date? {
        parseDate(date: releaseDate)
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


// MARK: DataParser (not used)

func parseDate(date: String?) -> Date? {
    guard let date = date else { return nil }

    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    return formatter.date(from: date)
}

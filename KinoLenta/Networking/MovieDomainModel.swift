//
//  NetworkItemModel.swift
//  KinoLenta
//
//  Created by Max Nigmatulin on 11.12.2021.
//

import Foundation



struct MovieDomainModel: Codable {
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
    let releaseDate: Date?

    init(movieDTO: MovieModel) {
        self.id = movieDTO.id
        self.title = movieDTO.title
        self.overview = movieDTO.overview
        self.genres = movieDTO.genres
        self.popularity = movieDTO.popularity
        self.voteAverage = movieDTO.voteAverage
        self.voteCount = movieDTO.voteCount
        self.backdropPath = movieDTO.backdropURL
        self.video = movieDTO.video
        self.runtime = movieDTO.runtime
        self.releaseDate = parseDate(date: movieDTO.releaseDate)
    }
    
    init(tvDTO: TVModel) {
        self.id = tvDTO.id
        self.title = tvDTO.name
        self.overview = tvDTO.overview
        self.genres = tvDTO.genres
        self.popularity = tvDTO.popularity
        self.voteAverage = tvDTO.voteAverage
        self.voteCount = tvDTO.voteCount
        self.backdropPath = URL(string: tvDTO.backdropURL) ?? nil
        self.video = false
        self.runtime = tvDTO.episodeRunTime.reduce(0, +) 
        self.releaseDate = parseDate(date: tvDTO.firstAirDate)
    }
    
}

// MARK: DataParser
private func parseDate(date: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.date(from: date)
}

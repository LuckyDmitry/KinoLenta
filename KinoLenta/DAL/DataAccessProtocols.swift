//
//  Protocols.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation

enum MovieType {
    case tv
    case movie
}

protocol MovieSearchService {
    func search(query: String) -> [MovieModel]
    
    func discover(
        genre: [Genre],
        yearRange: Range<Int>?,
        ratingRange: Range<Int>?
    ) -> [MovieModel]
}

protocol MovieCompilationService {
    func getPopular() -> [MovieModel]
    func getTopRated() -> [MovieModel]
    func getTrending() -> [MovieModel]
}

protocol MovieInfoService {
    func getById(_ id: Int) -> [MovieModel]
    func getRecommendations(for movie: MovieModel) -> [MovieModel]
    func getSimilar(to movie: MovieModel) -> [MovieModel]
}

enum SavedMovieOption {
    case viewed
    case all
}

protocol SavedMovieService {
    func getSavedMovies(option: SavedMovieOption) -> [MovieModel]
}


//
//  Protocols.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation


enum SortOption {
    case rating
    case popularity
//    ...
}

protocol MovieSearchService {
    func search(str: String) -> [MovieModel]
    
    func search(
        genre: Genre,
        sortBy: SortOption,
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
    func getById(id: Int) -> [MovieModel]
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


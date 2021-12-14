//
//  Protocols.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation


protocol MovieSearchService {
    func search(query: String) -> [QueryMovieModel]
    
    func discover(
        genre: [Genre],
        yearRange: ClosedRange<Int>?,
        ratingRange: ClosedRange<Int>?
    ) -> [QueryMovieModel]
}

protocol MovieCompilationService {
    func getPopular() -> [QueryMovieModel]
    func getTopRated() -> [QueryMovieModel]
    func getTrending() -> [QueryMovieModel]
}

protocol MovieInfoService {
    func getById(_ id: Int) -> [MovieDomainModel]
    func getRecommendations(for movie: MovieDomainModel) -> [MovieDomainModel]
    func getSimilar(to movie: MovieDomainModel) -> [MovieDomainModel]
}

enum SavedMovieOption {
    case viewed
    case all
}

protocol SavedMovieService {
    func getSavedMovies(option: SavedMovieOption) -> [MovieDomainModel]
}


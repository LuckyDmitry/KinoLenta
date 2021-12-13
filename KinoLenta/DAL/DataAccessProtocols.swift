//
//  Protocols.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation


protocol MovieSearchService {
    func search(query: String) -> [MovieDomainModel]
    
    func discover(
        genre: [Genre],
        yearRange: Range<Int>?,
        ratingRange: Range<Int>?
    ) -> [MovieDomainModel]
}

protocol MovieCompilationService {
    func getPopular() -> [MovieDomainModel]
    func getTopRated() -> [MovieDomainModel]
    func getTrending() -> [MovieDomainModel]
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


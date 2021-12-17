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

enum SavedMovieOption: String {
    case viewed = "ViewedMovies"
    case wishToWatch = "WishMovies"
    
    var description: String {
        switch self {
        case .viewed:
            return "Просмотреное"
        case .wishToWatch:
            return "Посмотреть"
        }
    }
}

protocol SavedMovieService {
    func getSavedMovies(option: SavedMovieOption, completion: ((Result<[MovieDomainModel], Error>) -> ())?)
    func removeMovies(_ movies: [MovieDomainModel], directoryType type: SavedMovieOption, completion: ((Error?) -> ())?)
    func saveMovies(_ movies: [MovieDomainModel], folderType type: SavedMovieOption, completion: ((Error?) -> ())?)
    func moveMovies(_ movies: [MovieDomainModel],
                    from initType: SavedMovieOption,
                    to destType: SavedMovieOption,
                    completion: ((Error?) -> ())?)
}


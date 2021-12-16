//
//  DataManager.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation

class DataManager {
    let cacheService: Caching
    let networkingService: Networking
    
    init(cacheService: Caching, networkingService: Networking) {
        
        self.cacheService = cacheService
        self.networkingService = networkingService
    }
}

// MARK: Search
extension DataManager: MovieSearchService {
    func search(query: String) -> [QueryMovieModel] { [] }
    
    func discover(genre: [Genre], yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Int>?) -> [QueryMovieModel] { [] }

}

// MARK: Compilation
extension DataManager: MovieCompilationService {
    func getPopular() -> [QueryMovieModel] {
        return []
    }
    
    func getTopRated() -> [QueryMovieModel] { return [] }
    
    func getTrending() -> [QueryMovieModel] { return [] }
}

// MARK: Movie
extension DataManager: MovieInfoService {
    func getById(_ id: Int) -> [MovieDomainModel] { return [] }
    
    func getRecommendations(for movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
    
    func getSimilar(to movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
}

// MARK: User movies
extension DataManager: SavedMovieService {
    func getSavedMovies(option: SavedMovieOption, completion: @escaping (Result<[MovieDomainModel], Error>) -> ()) {}
    
    func removeMovies(_ movies: [MovieDomainModel], directoryType type: SavedMovieOption, completion: ((Error?) -> ())?) {}
    
    func saveMovies(_ movies: [MovieDomainModel], folderType type: SavedMovieOption, completion: ((Error?) -> ())?) {}
    
    func changeDirectoryMovies(_ movies: [MovieDomainModel], from initType: SavedMovieOption, to destType: SavedMovieOption, completion: ((Error?) -> ())?) {}
}

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
    func search(query: String) -> [MovieModel] { [] }
    
    func discover(genre: [Genre], yearRange: Range<Int>?, ratingRange: Range<Int>?) -> [MovieModel] { [] }

}

// MARK: Compilation
extension DataManager: MovieCompilationService {
    func getPopular() -> [MovieModel] { return [] }
    
    func getTopRated() -> [MovieModel] { return [] }
    
    func getTrending() -> [MovieModel] { return [] }
}

// MARK: Movie
extension DataManager: MovieInfoService {
    func getById(_ id: Int) -> [MovieModel] { return [] }
    
    func getRecommendations(for movie: MovieModel) -> [MovieModel] { return [] }
    
    func getSimilar(to movie: MovieModel) -> [MovieModel] { return [] }
}

// MARK: User movies
extension DataManager: SavedMovieService {
    func getSavedMovies(option: SavedMovieOption) -> [MovieModel] { [] }
}

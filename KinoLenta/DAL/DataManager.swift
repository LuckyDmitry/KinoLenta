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
    func search(query: String) -> [SearchModel] { [] }
    
    func discover(genre: [Genre], yearRange: Range<Int>?, ratingRange: Range<Int>?) -> [SearchModel] { [] }

}

// MARK: Compilation
extension DataManager: MovieCompilationService {
    func getPopular() -> [MovieDomainModel] { return [] }
    
    func getTopRated() -> [MovieDomainModel] { return [] }
    
    func getTrending() -> [MovieDomainModel] { return [] }
}

// MARK: Movie
extension DataManager: MovieInfoService {
    func getById(_ id: Int) -> [MovieDomainModel] { return [] }
    
    func getRecommendations(for movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
    
    func getSimilar(to movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
}

// MARK: User movies
extension DataManager: SavedMovieService {
    func getSavedMovies(option: SavedMovieOption) -> [MovieDomainModel] { [] }
}

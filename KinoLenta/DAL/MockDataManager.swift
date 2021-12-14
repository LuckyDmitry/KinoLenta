//
//  MockDataManager.swift
//  KinoLenta
//
//  Created by user on 14.12.2021.
//

import Foundation


//enum MockJsonPaths: String {
//    case search = "/Users/user/Data/swift/kinolenta/mock_responses/multisearch_response.json"
//    case movieTopRated = "/Users/user/Data/swift/kinolenta/mock_responses/top_rated_movies.json"
//    case moviePopular = "/Users/user/Data/swift/kinolenta/mock_responses/popular_movies.json"
//    case movieDiscoverHorrorRuRegion = "/Users/user/Data/swift/kinolenta/mock_responses/discover_horrors_ru_region.json"
//
//    var fileURL: URL {
//        return URL(fileURLWithPath: self.rawValue)
//    }
//}

fileprivate func getJsonResourceURL(resource: String) -> URL? {
    return Bundle.main.url(forResource: resource, withExtension: "json")
}

enum MockJsonPaths {
    case search
    case movieTopRated
    case moviePopular
    case movieDiscoverHorrorRuRegion
    
    var fileURL: URL {
        switch self {
        case .search:
//            TODO:вынести в приватный методы, переименовать файлы согласно какому-нибудь паттерну
            return getJsonResourceURL(resource: "multisearch_response")!
        case .movieTopRated:
            return getJsonResourceURL(resource: "top_rated_movies")!
        case .moviePopular:
            return getJsonResourceURL(resource: "popular_movies")!
        case .movieDiscoverHorrorRuRegion:
            return getJsonResourceURL(resource: "discover_horrors_ru_region")!
        }
    }
}

func readJsonData(fileURL: URL) -> Data? {
    if let jsonData = try? Data(contentsOf: fileURL) {
        return jsonData
    }
    return nil
}

func parseMovieModel(fileURL: URL) -> [MovieDomainModel] {
    guard let rawData = readJsonData(fileURL: fileURL) else {
        return []
    }
    
    let topDict = try? JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any]
    guard let container = topDict?["results"] as? [[String: Any]] else { return [] }
    
    return container.compactMap {
        guard let data = try? JSONSerialization.data(withJSONObject: $0, options: []) else { return nil }
        if let movie = try? JSONDecoder().decode(MovieModel.self, from: data) {
            return MovieDomainModel(movieDTO: movie)
        }
        if let tvShow = try? JSONDecoder().decode(TVModel.self, from: data) {
            return MovieDomainModel(tvDTO: tvShow)
        }
        return nil
    }
}

func parseSearchResults(fileURL: URL) -> [SearchModel] {
    guard let rawData = readJsonData(fileURL: fileURL) else {
        return []
    }
    
    let topDict = try? JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any]
    guard let container = topDict?["results"] as? [[String: Any]] else { return [] }

    return container.compactMap {
        guard let data = try? JSONSerialization.data(withJSONObject: $0, options: []) else { return nil }
        if let searchModel = try? JSONDecoder().decode(SearchModel.self, from: data) {
            return searchModel
        }
        return nil
    }
}


class MockDataManager {

}

// MARK: Search
extension MockDataManager: MovieSearchService {
    func search(query: String) -> [SearchModel] {
        let result = parseSearchResults(fileURL: MockJsonPaths.search.fileURL)
        return result
    }
    
    func discover(genre: [Genre], yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Int>?) -> [SearchModel] {
        let result = parseSearchResults(fileURL: MockJsonPaths.movieDiscoverHorrorRuRegion.fileURL)
        return result
    }

}

// MARK: Compilation
extension MockDataManager: MovieCompilationService {
    func getPopular() -> [MovieDomainModel] {
        let result = parseMovieModel(fileURL: MockJsonPaths.moviePopular.fileURL)
        
        return result
    }
    
    func getTopRated() -> [MovieDomainModel] {
        let result = parseMovieModel(fileURL: MockJsonPaths.movieTopRated.fileURL)
        return result
    }
    
    func getTrending() -> [MovieDomainModel] { return [] }
}

// MARK: Movie
extension MockDataManager: MovieInfoService {
    func getById(_ id: Int) -> [MovieDomainModel] { return [] }
    
    func getRecommendations(for movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
    
    func getSimilar(to movie: MovieDomainModel) -> [MovieDomainModel] { return [] }
}

// MARK: User movies
extension MockDataManager: SavedMovieService {
    func getSavedMovies(option: SavedMovieOption) -> [MovieDomainModel] { [] }
}

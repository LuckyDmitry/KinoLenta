//
//  MockDataManager.swift
//  KinoLenta
//
//  Created by user on 14.12.2021.
//

import Foundation

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
//            TODO: переименовать файлы согласно какому-нибудь паттерну
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

func parseQueryMovieModel(fileURL: URL) -> [QueryMovieModel] {
    guard let rawData = readJsonData(fileURL: fileURL) else {
        return []
    }
    
    let topDict = try? JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any]
    guard let container = topDict?["results"] as? [[String: Any]] else { return [] }
    
    return container.compactMap {
        guard let data = try? JSONSerialization.data(withJSONObject: $0, options: []) else { return nil }
        if let movie = try? JSONDecoder().decode(QueryMovieModel.self, from: data) {
            return movie
        }
        return nil
    }
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
    
    func search(query: String) -> [QueryMovieModel] {
        let result = parseQueryMovieModel(fileURL: MockJsonPaths.search.fileURL)
        return result
    }
    
    func discover(genre: [Genre], yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Int>?) -> [QueryMovieModel] {
        let result = parseQueryMovieModel(fileURL: MockJsonPaths.movieDiscoverHorrorRuRegion.fileURL)
        return result
    }

}

// MARK: Compilation
extension MockDataManager: MovieCompilationService {
    func getPopular() -> [QueryMovieModel] {
        let result = parseQueryMovieModel(fileURL: MockJsonPaths.moviePopular.fileURL)
        
        return result
    }
    
    func getTopRated() -> [QueryMovieModel] {
        let result = parseQueryMovieModel(fileURL: MockJsonPaths.movieTopRated.fileURL)
        return result
    }
    
    func getTrending() -> [QueryMovieModel] { return [] }
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

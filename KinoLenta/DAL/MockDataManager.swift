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
    case movieGenrePath
    case tvGenrePath

    var fileURL: URL {
        switch self {
        case .search:
            return getJsonResourceURL(resource: "tv_movies_multisearch")!
        case .movieTopRated:
            return getJsonResourceURL(resource: "movies_top_rated")!
        case .moviePopular:
            return getJsonResourceURL(resource: "movies_popular")!
        case .movieDiscoverHorrorRuRegion:
            return getJsonResourceURL(resource: "movie_discover_horrors_ru_region")!
        case .movieGenrePath:
            return getJsonResourceURL(resource: "movie_genres_ru")!
        case .tvGenrePath:
            return getJsonResourceURL(resource: "tv_genres_ru")!
        }
    }
}

func readJsonData(fileURL: URL) throws -> Data {
    return try Data(contentsOf: fileURL)
}

func parseJsonFromData<T: Decodable>(fileURL: URL) -> [T] {
    do {
        let data = try readJsonData(fileURL: fileURL)
        let parsed: [T] = parseModelFromResponse(data: data)
        return parsed
    } catch {
        print(error)
        return []
    }
}

func parseModelFromResponse<T: Decodable>(data: Data) -> [T] {
    let topDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    guard let rawContainer = topDict?["results"] as? [[String: Any]] else { return [] }

    return tryParseWithObj(data: rawContainer)
}

func tryParseWithObj<T: Decodable>(data: [[String: Any]]) -> [T] {
    data.compactMap {
        guard let data = try? JSONSerialization.data(withJSONObject: $0, options: []) else { return nil }
        if let movie = try? JSONDecoder().decode(T.self, from: data) {
            return movie
        }
        return nil
    }
}

func parseObj<T: Decodable>(data: Data) throws -> T {
    return try JSONDecoder().decode(T.self, from: data)
}

class MockDataManager {
}

// MARK: Search

extension MockDataManager: MovieSearchService {
    func search(query: String) -> [QueryMovieModel] {
        let result: [QueryMovieModel] = parseJsonFromData(fileURL: MockJsonPaths.search.fileURL)
        return result
    }

    func discover(genre: [Genre], yearRange: ClosedRange<Int>?, ratingRange: ClosedRange<Int>?) -> [QueryMovieModel] {
        let result: [QueryMovieModel] = parseJsonFromData(fileURL: MockJsonPaths.movieDiscoverHorrorRuRegion.fileURL)
        return result
    }
}

// MARK: Compilation

extension MockDataManager: MovieCompilationService {
    func getPopular() -> [QueryMovieModel] {
        let result: [QueryMovieModel] = parseJsonFromData(fileURL: MockJsonPaths.moviePopular.fileURL)
        return result
    }

    func getTopRated() -> [QueryMovieModel] {
        let result: [QueryMovieModel] = parseJsonFromData(fileURL: MockJsonPaths.movieTopRated.fileURL)
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
    func getSavedMovies(option: SavedMovieOption, completion: @escaping (Result<[MovieDomainModel], Error>) -> ()) {}

    func removeMovies(
        _ movies: [MovieDomainModel],
        directoryType type: SavedMovieOption,
        completion: ((Error?) -> ())?
    ) {}

    func saveMovies(_ movies: [MovieDomainModel], folderType type: SavedMovieOption, completion: ((Error?) -> ())?) {}

    func changeDirectoryMovies(
        _ movies: [MovieDomainModel],
        from initType: SavedMovieOption,
        to destType: SavedMovieOption,
        completion: ((Error?) -> ())?
    ) {}
}

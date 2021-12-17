//
//  Caching.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 10.12.2021.
//

import Foundation

typealias Caching = SavedMovieService

private let fileManager: FileManager = .default

func formatUrl(folderUrl url: URL, fileName name: String, fileExtension: String = "json") -> URL {
    return url.appendingPathComponent(name).appendingPathExtension(fileExtension)
}

func getUrlFolderBy(folderType type: SavedMovieOption) throws -> URL {
    return try fileManager.url(for: .libraryDirectory,
                                  in: .userDomainMask,
                                  appropriateFor: nil,
                                  create: true).appendingPathComponent(type.rawValue,
                                                                       isDirectory: true)
}

func createDirectoryIfNeeded(at url: URL) throws {
    guard !fileManager.fileExists(atPath: url.path) else { return }
    return try fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
}

final class CacheService: Caching {
    // TODO: Add caching
    
    func getSavedMovies(option: SavedMovieOption, completion: @escaping(Result<[MovieDomainModel], Error>) -> ()) {
        DispatchQueue.global().async {
            do {
                let folderUrl = try getUrlFolderBy(folderType: option)
                let contentsOfDirectory = try fileManager.contentsOfDirectory(atPath: folderUrl.path)
                
                let contentData: [Data] = contentsOfDirectory.compactMap { pathAsString in
                    let fileUrl = folderUrl.appendingPathComponent(pathAsString)
                    return fileManager.contents(atPath: fileUrl.path)
                }
                
                let decoder = JSONDecoder()
                let movieItems = contentData.compactMap { data in
                    return try? decoder.decode(MovieDomainModel.self, from: data)
                }
                completion(.success(movieItems))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func removeMovies(_ movies: [MovieDomainModel], directoryType type: SavedMovieOption, completion: ((Error?) -> ())?) {
        DispatchQueue.global().async {
            do {
                let url = try getUrlFolderBy(folderType: type)
                let contentsOfDirectory = try fileManager.contentsOfDirectory(atPath: url.path)
                
                let fileNamesSet = Set(contentsOfDirectory)
                
                for movie in movies {
                    let movieIdAsString = "\(movie.id)"
                    
                    if fileNamesSet.contains(movieIdAsString + ".\(Consts.fileExtension)") {
                        let urlToRemove = formatUrl(folderUrl: url, fileName: movieIdAsString)
                        try fileManager.removeItem(at: urlToRemove)
                    }
                }
            } catch {
                completion?(error)
            }
        }
    }
    
    // Called when we need to move movie from one folder to another
    func changeDirectoryMovies(_ movies: [MovieDomainModel],
                               from initType: SavedMovieOption,
                               to destType: SavedMovieOption,
                               completion: ((Error?) -> ())?) {
        assert(initType != destType)
        removeMovies(movies, directoryType: initType, completion: completion)
        saveMovies(movies, folderType: destType, completion: completion)
    }
    
    func saveMovies(_ movies: [MovieDomainModel], folderType type: SavedMovieOption, completion: ((Error?) -> ())?) {
        
        DispatchQueue.global().async {
            do {
                let folderUrl = try getUrlFolderBy(folderType: type)
                try createDirectoryIfNeeded(at: folderUrl)
                
                let encoder = JSONEncoder()
                
                for movie in movies {
                    let movieIdAsString = "\(movie.id)"
                    let fileUrl = formatUrl(folderUrl: folderUrl, fileName: movieIdAsString)
                    let data = try encoder.encode(movie)
                    try data.write(to: fileUrl)
                }
            } catch {
                completion?(error)
            }
        }
    }
    
    private enum PathConsts {
        static let wishesMovieDirectoryName = "WishesMovies"
        static let viewedMoviesDirectoryName = "ViewedMovies"
    }
    
    private enum Consts {
        static let fileExtension = "json"
    }
}

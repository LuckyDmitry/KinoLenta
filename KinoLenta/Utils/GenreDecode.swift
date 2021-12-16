//
//  GenreDecode.swift
//  KinoLenta
//
//  Created by user on 15.12.2021.
//

import Foundation

final class GenreDecoderContainer {
    
    static let sharedMovieManager: GenreDecoder = .init(fileURL: MockJsonPaths.movieGenrePath.fileURL)
    static let sharedTVManager: GenreDecoder = .init(fileURL: MockJsonPaths.tvGenrePath.fileURL)
    
    private init() {
        
    }
}


class GenreDecoder {
    
    private var intIndexed: [Int: String] = [:]
    private var stringIndexed: [String: Int] = [:]
    
    private init(genres: [Int: String]) {
        intIndexed = genres
        for pair in intIndexed {
            stringIndexed[pair.value] = pair.key
        }
    }
    
    convenience init(fileURL: URL) {
        guard let data = try? readJsonData(fileURL: fileURL) else {
            self.init(genres: [:])
            return
        }
        
        self.init(jsonData: data)
    }
    
    convenience init(jsonData: Data) {
        let topDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        guard let container = topDict?["genres"] as? [[String: Any]] else {
            self.init(genres: [:])
            return
        }

        var genresDecoded: [Int: String] = [:]

        container.forEach { genreItem in
            guard let genreItemID = genreItem["id"] as? Int,
                  let genreItemName = genreItem["name"] as? String
            else {
                return
            }
            genresDecoded[genreItemID] = genreItemName
        }

        self.init(genres: genresDecoded)
    }
}

extension GenreDecoder {
    func getByID(_ id: Int) -> String? {
        guard let solution = intIndexed[id] else { return nil }
        return solution
    }
    
    func getByName(_ name: String) -> Int? {
        guard let solution = stringIndexed[name] else { return nil }
        return solution
    }
}

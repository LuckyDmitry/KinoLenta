//
//  GenreDecode.swift
//  KinoLenta
//
//  Created by user on 15.12.2021.
//

import Foundation


//enum GenreDecoderContainer {
//    case movies
//    case tv
//
//    var shared: GenreDecoder {
//        switch (self) {
//        case .movies:
//            return GenreDecoder(fileURL: MockJsonPaths.movieGenrePath.fileURL)
//        case .tv:
//            return GenreDecoder(fileURL: MockJsonPaths.tvGenrePath.fileURL)
//        }
//    }
//}

enum GenreDecoderContainer {
    static let sharedMovieManager = GenreDecoder(fileURL: MockJsonPaths.movieGenrePath.fileURL)
    static let sharedTVManager = GenreDecoder(fileURL: MockJsonPaths.tvGenrePath.fileURL)
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
        
        self.init(genres: Dictionary(uniqueKeysWithValues: container.compactMap {
                    guard let genreItemID = $0["id"] as? Int,
                          let genreItemName = $0["name"] as? String else { return nil }
                    return (genreItemID, genreItemName)
                }))
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

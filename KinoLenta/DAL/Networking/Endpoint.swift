//
//  Endpoints.swift
//  KinoLenta
//
//  Created by Alexander Denisov on 18.12.2021.
//

import Foundation

enum Endpoint {
    static let apiBaseURL = URL(string: "https://api.themoviedb.org")!

    static func originalImage(path: String) -> URL? {
        originalImageBaseURL?.appendingPathComponent(path)
    }

    // 500px size
    static func smallImage(path: String) -> URL? {
        smallImageBaseURL?.appendingPathComponent(path)
    }
}

private let originalImageBaseURL = URL(string: "https://image.tmdb.org/t/p/original/")
private let smallImageBaseURL = URL(string: "https://image.tmdb.org/t/p/original/")

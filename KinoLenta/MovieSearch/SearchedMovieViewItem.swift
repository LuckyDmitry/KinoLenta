//
//  SearchedmovieViewItem.swift
//  KinoLenta
//
//  Created by Dmitry Trifonov on 10.12.2021.
//

import UIKit

struct SearchedMovieViewItem {
    let id: Int
    let imageURL: URL?
    let title: String
    let genre: String?
    let overview: String?
    let rating: Double?
}

extension Collection where Element == QueryMovieModel {
    func toSearchedMovieViewItems(genreSeparator: String = ", ") -> [SearchedMovieViewItem] {
        map {
            SearchedMovieViewItem(
                id: $0.id,
                imageURL: $0.backdropURL ?? $0.posterURL,
                title: $0.title,
                genre: $0.genreIDS?.compactMap {
                    GenreDecoderContainer.sharedMovieManager.getByID($0)
                }.joined(separator: genreSeparator).firstUppercased,
                overview: $0.overview,
                rating: $0.voteAverage
            )
        }
    }
}

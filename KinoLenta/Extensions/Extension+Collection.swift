//
//  Extension+Array.swift
//  KinoLenta
//
//  Created by user on 15.12.2021.
//

import Foundation


extension Collection where Element == QueryMovieModel {
    func toSearchedMovieViewItems(genreSeparator: String = ", ") -> [SearchedMovieViewItem] {
        self.map {
            SearchedMovieViewItem(
                id: $0.id,
                image: "https://image.tmdb.org/t/p/original/" + ($0.backdropPath ?? ""),
                title: $0.title,
                genre: $0.genreIDS?.compactMap {
                    GenreDecoderContainer.sharedMovieManager.getByID($0)
                }.joined(separator: genreSeparator).firstUppercased,
                description: $0.overview,
                rating: $0.voteAverage
            )
        }
    }
}

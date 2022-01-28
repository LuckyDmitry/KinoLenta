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
                imageURL: $0.backdropURL ?? $0.posterURL,
                title: $0.title,
                genre: $0.genreIDS?.compactMap {
                    GenreDecoderContainer.sharedMovieManager.getByID($0)
                }.joined(separator: genreSeparator).firstUppercased,
                overview: $0.overview,
                rating: $0.voteAverage,
                buttonTitle: "Watch later"
            )
        }
    }
}

extension Collection where Element == QueryMovieModel {
    func toCarouselData(genreSeparator: String = ", ") -> [CarouselData] {
        self.map {
            CarouselData(id: $0.id, image: $0.backdropURL, rating: $0.voteAverage, name: $0.title)
        }
    }
}

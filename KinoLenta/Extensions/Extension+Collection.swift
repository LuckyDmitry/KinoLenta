//
//  Extension+Array.swift
//  KinoLenta
//
//  Created by user on 15.12.2021.
//

import Foundation


extension Collection where Element == QueryMovieModel {
    func convertToSearchedMovieViewItem() -> [SearchedMovieViewItem] {
        return self.map { queryModel in
            let searchModel = SearchedMovieViewItem(
                image: nil,
                title: queryModel.title,
                genre: nil,
                description: queryModel.overview,
                rating: queryModel.voteAverage)
            return searchModel
        }
    }
}

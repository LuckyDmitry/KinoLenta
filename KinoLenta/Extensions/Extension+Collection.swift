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
            var genres: String = ""
            
            if let genreIDs = queryModel.genreIDS {
                
                for genreID in genreIDs {
                    guard let decodedGenre = GenreDecoderContainer
                            .sharedMovieManager
                            .getByID(genreID)
                    else { continue }
                    
                    genres += "\(decodedGenre) "
                }
            }
            
            let searchModel = SearchedMovieViewItem(
                image: nil,
                title: queryModel.title,
                genre: genres,
                description: queryModel.overview,
                rating: queryModel.voteAverage)
            return searchModel
        }
    }
}

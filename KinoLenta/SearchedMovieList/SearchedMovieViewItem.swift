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
    let buttonTitle: String
    
    var domainModel: MovieDomainModel {
        MovieDomainModel(adult: nil, backdropPath: nil, budget: nil, genres: nil, homepage: nil, id: id, imdbID: nil, originalLanguage: nil, originalTitle: title, overview: overview, popularity: nil, posterPath: nil, productionCompanies: nil, productionCountries: nil, releaseDate: nil, revenue: nil, runtime: nil, spokenLanguages: nil, status: nil, tagline: nil, title: title, video: nil, voteAverage: nil, voteCount: nil)
    }
}

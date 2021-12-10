//
//  FilmDTO.swift
//  Kinolenta
//
//  Created by Max Nigmatulin on 09.12.2021.
//

import Foundation


enum Genre: String {
    case horror
    case comedy
    case thriller
    case drama
//    ...

}

struct MovieModel {
    
    let id: String
    let title: String
    let tagline: String
    
    let genres: [(Int, Genre)]
    
    let poster: URL
    
    let overview: String
    let popularity: Int
    let voteAverage: Float
    let voteCount: Int
    
}

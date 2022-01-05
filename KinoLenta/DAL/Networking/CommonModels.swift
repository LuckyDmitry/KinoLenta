//
//  CommonModels.swift
//  KinoLenta
//
//  Created by Max Nigmatulin on 11.12.2021.
//

import Foundation


// MARK: - ProductionCountry

struct ProductionCountry: Codable, Hashable {
    let iso3166_1: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - Genre

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany

struct ProductionCompany: Codable, Hashable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

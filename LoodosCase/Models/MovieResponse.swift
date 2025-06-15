//
//  MovieResponser.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

import Foundation

struct MovieResponse: Decodable {
    let search: [Movie]?
    let totalResults: String?
    let response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

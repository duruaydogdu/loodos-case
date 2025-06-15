//
//  MovieDetail.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 16.06.2025.
//

import Foundation

struct MovieDetail: Codable {
    let title: String
    let plot: String
    let genre: String
    let language: String
    let runtime: String
    let imdbRating: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case plot = "Plot"
        case genre = "Genre"
        case language = "Language"
        case runtime = "Runtime"
        case imdbRating = "imdbRating"
        case poster = "Poster"
    }
}

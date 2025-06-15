//
//  APIEndpoints.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

enum APIEndpoints {
    static func searchMovieURL(query: String) -> URL? {
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(Constants.API.baseURL)?apikey=\(Constants.API.apiKey)&s=\(queryEncoded)"
        return URL(string: urlString)
    }

    static func movieDetailURL(imdbID: String) -> URL? {
        let urlString = "\(Constants.API.baseURL)?apikey=\(Constants.API.apiKey)&i=\(imdbID)"
        return URL(string: urlString)
    }
}


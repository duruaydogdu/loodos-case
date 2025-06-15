//
//  MovieService.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

protocol MovieServiceProtocol {
    func searchMovies(query: String) async throws -> MovieResponse
    func fetchMovieDetail(imdbID: String) async throws -> MovieDetail
}

final class MovieService: MovieServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }

    func searchMovies(query: String) async throws -> MovieResponse {
        guard let url = APIEndpoints.searchMovieURL(query: query) else {
            throw URLError(.badURL)
        }

        return try await networkManager.request(url: url, type: MovieResponse.self)
    }

    func fetchMovieDetail(imdbID: String) async throws -> MovieDetail {
        guard let url = APIEndpoints.movieDetailURL(imdbID: imdbID) else {
            throw URLError(.badURL)
        }

        return try await networkManager.request(url: url, type: MovieDetail.self)
    }
}


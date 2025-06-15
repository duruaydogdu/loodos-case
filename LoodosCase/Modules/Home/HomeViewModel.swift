//
//  HomeViewModel.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

final class HomeViewModel {

    // MARK: - Dependencies
    private let movieService: MovieServiceProtocol

    // MARK: - Data
    private(set) var movies: [Movie] = []

    // MARK: - Bindable Callbacks
    var onMoviesUpdated: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Init
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }

    // MARK: - Actions
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            self.movies = []
            self.onMoviesUpdated?()
            return
        }

        onLoadingStateChange?(true)

        Task {
            do {
                let response = try await movieService.searchMovies(query: query)
                self.movies = response.search ?? []
                print("API'den gelen film sayısı: \(self.movies.count)")
            } catch {
                print("Film arama hatası: \(error.localizedDescription)")
                self.movies = []
            }

            DispatchQueue.main.async {
                self.onLoadingStateChange?(false)
                self.onMoviesUpdated?()
            }
        }
    }
}

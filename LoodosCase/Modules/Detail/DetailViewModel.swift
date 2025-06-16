//
//  DetailViewModel.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

final class DetailViewModel {

    // MARK: - Dependencies
    private let movieService: MovieServiceProtocol

    // MARK: - Bindable Outputs
    var onDetailLoaded: ((MovieDetail) -> Void)?

    // MARK: - Init
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }

    // MARK: - Actions
    func fetchMovieDetail(imdbID: String) {
        Task {
            do {
                print("VM-FETCH \(imdbID)")
                let detail = try await movieService.fetchMovieDetail(imdbID: imdbID)
                DispatchQueue.main.async { self.onDetailLoaded?(detail) }
            } catch {
                print("VM-ERROR", error.localizedDescription)
            }
        }
    }
}

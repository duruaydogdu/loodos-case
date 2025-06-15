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
        guard let detailLoaded = onDetailLoaded else {
            print("onDetailLoaded atanmadı. ViewModel bind edilmeden çağrılmış olabilir.")
            return
        }

        Task {
            do {
                print("Detay verisi isteniyor: \(imdbID)")
                let detail = try await movieService.fetchMovieDetail(imdbID: imdbID)
                DispatchQueue.main.async {
                    detailLoaded(detail)
                }
            } catch {
                print("Detay verisi çekilemedi: \(error.localizedDescription)")
            }
        }
    }
}

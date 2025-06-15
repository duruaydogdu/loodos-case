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
    var onLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Init
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }

    // MARK: - Actions
    func fetchMovieDetail(imdbID: String) {
        // Log ile debug edelim
        if onLoadingStateChange == nil {
            print("onLoadingStateChange atanmadı.")
        }
        if onDetailLoaded == nil {
            print("onDetailLoaded atanmadı.")
        }

        // Eğer bind edilmemişse, sessizce çık
        guard let loadingChange = onLoadingStateChange,
              let detailLoaded = onDetailLoaded else {
            print("ViewModel binding yapılmamış. fetchMovieDetail() erken çağrılmış olabilir.")
            return
        }

        loadingChange(true)

        Task {
            do {
                let detail = try await movieService.fetchMovieDetail(imdbID: imdbID)
                DispatchQueue.main.async {
                    loadingChange(false)
                    detailLoaded(detail)
                }
            } catch {
                print("Detay verisi çekme hatası: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    loadingChange(false)
                }
            }
        }
    }

}

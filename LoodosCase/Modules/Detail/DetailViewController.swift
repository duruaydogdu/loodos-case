//
//  DetailViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit
import Kingfisher
import FirebaseAnalytics

final class DetailViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!

    // MARK: - Properties
    var imdbID: String?
    private let viewModel = DetailViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail ekranı açıldı. imdbID: \(imdbID ?? "nil")")
        bindViewModel()
        fetchDetail()
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onDetailLoaded = { [weak self] detail in
            guard let self = self else { return }
            self.configure(with: detail)
            self.logAnalytics(for: detail)
        }
    }

    // MARK: - API
    private func fetchDetail() {
        guard let imdbID = imdbID else {
            print("IMDb ID bulunamadı.")
            return
        }
        viewModel.fetchMovieDetail(imdbID: imdbID)
    }

    // MARK: - UI Binding
    private func configure(with detail: MovieDetail) {
        print("Veriler yükleniyor: \(detail.title)")
        titleLabel.text = detail.title
        plotLabel.text = detail.plot
        runtimeLabel.text = detail.runtime
        genreLabel.text = detail.genre
        languageLabel.text = detail.language
        imdbRatingLabel.text = detail.imdbRating

        if let url = URL(string: detail.poster), detail.poster != "N/A" {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }

    // MARK: - Analytics
    private func logAnalytics(for detail: MovieDetail) {
        AnalyticsService.shared.logEvent(
            .movieDetailOpened(
                imdbID: imdbID ?? "",
                title: detail.title,
                rating: detail.imdbRating,
                genre: detail.genre
            )
        )
    }
}

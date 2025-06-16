//
//  DetailViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit
import Kingfisher
import FirebaseAnalytics
import UserNotifications

final class DetailViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var contentView : UIView!
    @IBOutlet private weak var posterImageView : UIImageView!
    @IBOutlet private weak var runtimeLabel : UILabel!
    @IBOutlet private weak var genreLabel : UILabel!
    @IBOutlet private weak var languageLabel : UILabel!
    @IBOutlet private weak var imdbRatingLabel : UILabel!
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var plotLabel : UILabel!
    @IBOutlet private weak var loadingIndicator : UIActivityIndicatorView!
    
    // MARK: Properties
    var imdbID: String? {
        didSet { if isViewLoaded { fetchIfNeeded() } }
    }

    private let viewModel = DetailViewModel()
    private var hasFetched = false

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        fetchIfNeeded()
    }

    // MARK: UI
    private func setupUI() {
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        contentView.isHidden = true
        loadingIndicator.startAnimating()
    }

    // MARK: Bind
    private func bindViewModel() {
        viewModel.onDetailLoaded = { [weak self] d in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.configure(with: d)
                self.logAnalytics(d)
                self.scheduleNotification(for: d.title)
            }
        }
    }

    // MARK: Fetch
    private func fetchIfNeeded() {
        guard !hasFetched, let id = imdbID else { return }
        hasFetched = true
        print("VC-FETCH \(id)")
        viewModel.fetchMovieDetail(imdbID: id)
    }

    // MARK: Configure UI
    private func configure(with d: MovieDetail) {
        loadingIndicator.stopAnimating()
        contentView.isHidden = false

        titleLabel.text = d.title
        plotLabel.text = d.plot
        runtimeLabel.attributedText = icon("clock", d.runtime)
        genreLabel.attributedText = icon("film",  d.genre)
        languageLabel.attributedText = icon("speaker.wave.2.fill", d.language)
        imdbRatingLabel.attributedText = icon("star.fill", d.imdbRating, .systemYellow)

        if d.poster != "N/A", let url = URL(string: d.poster) {
            posterImageView.kf.setImage(with: url,
                                        placeholder: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }

    // MARK: Helpers
    private func icon(_ sys: String, _ txt: String, _ clr: UIColor = .label) -> NSAttributedString {
        let att = NSTextAttachment()
        att.image = UIImage(systemName: sys)?
            .withTintColor(clr, renderingMode: .alwaysOriginal)
        att.bounds = CGRect(x: 0, y: -1, width: 16, height: 16)
        let res = NSMutableAttributedString(attachment: att)
        res.append(NSAttributedString(string: " \(txt)"))
        return res
    }

    private func logAnalytics(_ d: MovieDetail) {
        AnalyticsService.shared.logEvent(
            .movieDetailOpened(imdbID: imdbID ?? "",
                               title: d.title,
                               rating: d.imdbRating,
                               genre: d.genre))
    }

    private func scheduleNotification(for title: String) {
        let content = UNMutableNotificationContent()
        content.title = "Yeni Film İncelemesi"
        content.body = "\(title) detayları görüntülendi."
        content.sound = .default
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false))
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

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

    // MARK: - IBOutlets
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var imdbRatingLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!

    // MARK: - Properties
    var imdbID: String? {
        didSet {
            if isViewLoaded && !hasFetched, let imdbID = imdbID {
                fetchDetail(imdbID: imdbID)
            }
        }
    }
    private let viewModel = DetailViewModel()
    private var hasFetched = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Detail ekranı açıldı. imdbID: \(imdbID ?? "nil")")

        setupUI()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let imdbID = imdbID, !hasFetched {
            fetchDetail(imdbID: imdbID)
        }
    }

    // MARK: - Setup
    private func setupUI() {
        // Poster görseli tüm köşelere radius
        posterImageView.layer.cornerRadius = 12
        posterImageView.clipsToBounds = true

        // Başlık font ayarı
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onDetailLoaded = { [weak self] detail in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.configure(with: detail)
                self.logAnalytics(for: detail)
                self.triggerLocalNotification(for: detail.title)
            }
        }
    }

    // MARK: - API
    private func fetchDetail(imdbID: String) {
        hasFetched = true
        viewModel.fetchMovieDetail(imdbID: imdbID)
    }

    // MARK: - UI Binding
    private func configure(with detail: MovieDetail) {
        print("Veriler yükleniyor: \(detail.title)")

        titleLabel.text = detail.title
        plotLabel.text = detail.plot

        runtimeLabel.attributedText = iconText(systemName: "clock", text: detail.runtime)
        genreLabel.attributedText = iconText(systemName: "film", text: detail.genre)
        languageLabel.attributedText = iconText(systemName: "speaker.wave.2.fill", text: detail.language)
        imdbRatingLabel.attributedText = iconText(systemName: "star.fill", text: detail.imdbRating, iconColor: .systemYellow)

        if let url = URL(string: detail.poster), detail.poster != "N/A" {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }

    // MARK: - Icon + Text Helper
    private func iconText(systemName: String, text: String, iconColor: UIColor = .label) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: systemName)?.withTintColor(iconColor, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -1, width: 16, height: 16)

        let attributedString = NSMutableAttributedString(attachment: attachment)
        attributedString.append(NSAttributedString(string: " \(text)"))
        return attributedString
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

    // MARK: - Local Notification (Push simülasyonu)
    private func triggerLocalNotification(for title: String) {
        let content = UNMutableNotificationContent()
        content.title = "Yeni Film İncelemesi"
        content.body = "\(title) detayları görüntülendi."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gönderilemedi: \(error.localizedDescription)")
            } else {
                print("Local notification scheduled for: \(title)")
            }
        }
    }
}

//
//  MovieCollectionViewCell.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Kart görünümü
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.systemGray5.cgColor

        // Poster görünümü
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 8

        // Başlık
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center

        // Yıl
        yearLabel.font = .systemFont(ofSize: 12, weight: .regular)
        yearLabel.textColor = .secondaryLabel
        yearLabel.textAlignment = .center
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year

        if movie.poster != "N/A", let url = URL(string: movie.poster) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
}

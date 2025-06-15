//
//  MovieCollectionViewCell.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        print("MovieCollectionViewCell awakeFromNib çalıştı")
        contentView.backgroundColor = .systemYellow // test için görünür yap
    }

    func configure(with movie: Movie) {
        print("configure: \(movie.title)")
        titleLabel.text = movie.title
        yearLabel.text = movie.year

        if movie.poster != "N/A", let url = URL(string: movie.poster) {
            posterImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder")) { result in
                switch result {
                case .success(let value):
                    print("Poster yüklendi: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Görsel yüklenemedi: \(error)")
                }
            }
        } else {
            posterImageView.image = UIImage(named: "placeholder")
            print("Poster geçersiz veya 'N/A'")
        }
    }

}


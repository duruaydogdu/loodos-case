//
//  UIImageView+Kingfisher.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = nil) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }

        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.transition(.fade(0.2))]
        )
    }
}

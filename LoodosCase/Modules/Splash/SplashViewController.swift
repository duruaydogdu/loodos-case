//
//  SplashViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!

    private var viewModel: SplashViewModelProtocol = SplashViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.alpha = 0
        bindViewModel()
        viewModel.fetchSplashText()
    }

    private func bindViewModel() {
        viewModel.onTextFetched = { [weak self] text in
            DispatchQueue.main.async {
                self?.titleLabel.text = text
                UIView.animate(withDuration: 0.3) {
                    self?.titleLabel.alpha = 1
                }
            }
        }
    }

    private func proceedAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // TODO: Internet varsa segue veya kodla Home ekranına geç
        }
    }
}

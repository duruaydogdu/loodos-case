//
//  SplashViewController.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: SplashViewModelProtocol = SplashViewModel()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SplashViewController loaded")
        titleLabel.alpha = 0
        bindViewModel()
        viewModel.waitAndFetchSplashText()
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.onTextFetched = { [weak self] text in
            DispatchQueue.main.async {
                guard let self = self else { return }

                print("onTextFetched çağrıldı. Gelen text: \(text ?? "nil")")
                
                if let text = text {
                    self.titleLabel.text = text
                    UIView.animate(withDuration: 0.3) {
                        self.titleLabel.alpha = 1
                    }
                    self.proceedAfterDelay()
                } else {
                    self.showNoInternetAlert()
                }
            }
        }
    }

    // MARK: - Routing
    private func proceedAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            guard ConnectivityMonitor.shared.isConnected else {
                self.showNoInternetAlert()
                return
            }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeNav = storyboard.instantiateViewController(withIdentifier: "HomeNavController") as? UINavigationController {
                homeNav.modalPresentationStyle = .fullScreen
                self.present(homeNav, animated: true)
            } else {
                print("HomeNavController bulunamadı")
            }
        }
    }

    // MARK: - Alerts
    private func showNoInternetAlert() {
        let alert = UIAlertController(
            title: "Bağlantı Yok",
            message: "Lütfen internet bağlantınızı kontrol edin.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tekrar Dene", style: .default, handler: { _ in
            self.bindViewModel()
            self.viewModel.waitAndFetchSplashText()
        }))
        present(alert, animated: true)
    }
}

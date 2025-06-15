//
//  SplashViewModel.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

// MARK: - Protocol
protocol SplashViewModelProtocol {
    var onTextFetched: ((String?) -> Void)? { get set }
    func waitAndFetchSplashText()
}

// MARK: - ViewModel
final class SplashViewModel: SplashViewModelProtocol {

    // MARK: - Dependencies
    private let remoteConfigService: RemoteConfigServiceProtocol

    // MARK: - Bindable Output
    var onTextFetched: ((String?) -> Void)?

    // MARK: - Init
    init(remoteConfigService: RemoteConfigServiceProtocol = RemoteConfigService()) {
        self.remoteConfigService = remoteConfigService
    }

    // MARK: - Public API
    func waitAndFetchSplashText() {
        Task {
            while !ConnectivityMonitor.shared.isReady {
                print("NWPathMonitor hazır değil, bekleniyor...")
                try? await Task.sleep(nanoseconds: 200_000_000) // 0.2 saniye bekle
            }

            print("NWPathMonitor hazır, splash metni alınıyor...")
            fetchSplashText()
        }
    }

    // MARK: - Private Logic
    private func fetchSplashText() {
        guard ConnectivityMonitor.shared.isConnected else {
            print("İnternet bağlantısı yok")
            onTextFetched?(nil)
            return
        }

        remoteConfigService.fetchLoodosText { [weak self] text in
            print("RemoteConfig'ten gelen splash text: \(text ?? "nil")")
            self?.onTextFetched?(text)
        }
    }
}

//
//  SplashViewModel.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//


import Foundation

protocol SplashViewModelProtocol {
    var onTextFetched: ((String?) -> Void)? { get set }
    func waitAndFetchSplashText()
}

final class SplashViewModel: SplashViewModelProtocol {
    private let remoteConfigService: RemoteConfigServiceProtocol
    var onTextFetched: ((String?) -> Void)?

    init(remoteConfigService: RemoteConfigServiceProtocol = RemoteConfigService()) {
        self.remoteConfigService = remoteConfigService
    }

    func waitAndFetchSplashText() {
        Task {
            while !ConnectivityMonitor.shared.isReady {
                print("Bekleniyor: NWPathMonitor hazır değil")
                try? await Task.sleep(nanoseconds: 200_000_000)
            }

            print("NWPathMonitor hazır, fetchSplashText() çağrılıyor")
            fetchSplashText()
        }
    }

    private func fetchSplashText() {
        guard ConnectivityMonitor.shared.isConnected else {
            print("İnternet bağlantısı yok")
            onTextFetched?(nil)
            return
        }

        remoteConfigService.fetchLoodosText { [weak self] text in
            self?.onTextFetched?(text)
        }
    }
}


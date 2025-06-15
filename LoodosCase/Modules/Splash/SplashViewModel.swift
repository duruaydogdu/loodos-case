//
//  SplashViewModel.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

protocol SplashViewModelProtocol {
    var onTextFetched: ((String?) -> Void)? { get set }
    func fetchSplashText()
}

final class SplashViewModel: SplashViewModelProtocol {
    private var remoteConfigService: RemoteConfigServiceProtocol

    var onTextFetched: ((String?) -> Void)?

    init(remoteConfigService: RemoteConfigServiceProtocol = RemoteConfigService()) {
        self.remoteConfigService = remoteConfigService
    }

    func fetchSplashText() {
        remoteConfigService.fetchLoodosText { [weak self] text in
            self?.onTextFetched?(text)
        }
    }
}

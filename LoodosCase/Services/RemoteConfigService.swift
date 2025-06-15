//
//  RemoteConfigService.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import FirebaseRemoteConfig

protocol RemoteConfigServiceProtocol {
    func fetchLoodosText(completion: @escaping (String?) -> Void)
}

final class RemoteConfigService: RemoteConfigServiceProtocol {
    private let remoteConfig = RemoteConfig.remoteConfig()

    init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }

    func fetchLoodosText(completion: @escaping (String?) -> Void) {
        remoteConfig.fetchAndActivate { _, _ in
            let text = self.remoteConfig["loodos_text"].stringValue
            completion(text)
        }
    }
}



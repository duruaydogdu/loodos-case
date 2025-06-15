//
//  RemoteConfigService.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation
import FirebaseRemoteConfig

protocol RemoteConfigServiceProtocol {
    func fetchLoodosText(completion: @escaping (String?) -> Void)
}

final class RemoteConfigService: RemoteConfigServiceProtocol {
    private let remoteConfig: RemoteConfig

    init(remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()) {
        self.remoteConfig = remoteConfig

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0 // ✅ Her denemede fetch edilsin
        remoteConfig.configSettings = settings
    }

    func fetchLoodosText(completion: @escaping (String?) -> Void) {
        print("Firebase RemoteConfig fetch başlatıldı")

        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                print("Firebase fetch error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            print("Firebase fetch status: \(status.rawValue)")
            let loodosText = self.remoteConfig.configValue(forKey: "loodos_text").stringValue
            print("Firebase'den gelen loodos_text: \(loodosText ?? "nil")")
            completion(loodosText)
        }
    }
}



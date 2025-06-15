//
//  ConnectivityMonitor.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation
import Network

final class ConnectivityMonitor {
    static let shared = ConnectivityMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    private(set) var isConnected: Bool = false
    private(set) var isReady: Bool = false

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let connected = path.status == .satisfied
            print("NWPathMonitor güncellendi: \(connected)")
            self?.isConnected = connected
            self?.isReady = true
        }

        monitor.start(queue: queue)
    }
}



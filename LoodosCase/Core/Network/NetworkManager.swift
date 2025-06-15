//
//  NetworkManager.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(url: URL, type: T.Type) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    func request<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}


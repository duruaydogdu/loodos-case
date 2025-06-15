//
//  NetworkManager.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    func request<T: Decodable>(url: URLConvertible, type: T.Type) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    func request<T: Decodable>(url: URLConvertible, type: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decoded):
                        continuation.resume(returning: decoded)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}



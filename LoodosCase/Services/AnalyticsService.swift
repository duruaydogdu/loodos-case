//
//  AnalyticsService.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 15.06.2025.
//

import Foundation
import FirebaseAnalytics

enum AnalyticsEvent {
    case movieDetailOpened(imdbID: String, title: String, rating: String, genre: String)
    
    var name: String {
        switch self {
        case .movieDetailOpened:
            return "movie_detail_opened"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .movieDetailOpened(let imdbID, let title, let rating, let genre):
            return [
                "imdbID": imdbID,
                "title": title,
                "rating": rating,
                "genre": genre
            ]
        }
    }
}

final class AnalyticsService {
    static let shared = AnalyticsService()

    private init() {}

    func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
        print("[Analytics] Event logged: \(event.name)")
    }
}


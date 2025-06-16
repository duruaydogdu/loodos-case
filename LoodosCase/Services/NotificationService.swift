//
//  NotificationService.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 16.06.2025.
//

import Foundation
import FirebaseMessaging
import UserNotifications
import UIKit

final class NotificationService: NSObject {

    static let shared = NotificationService()

    func setup() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
            print("Notification permission granted: \(granted)")
        }

        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

// MARK: - MessagingDelegate

extension NotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "nil")")
    }
}

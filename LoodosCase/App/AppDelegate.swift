//
//  AppDelegate.swift
//  LoodosCase
//
//  Created by Duru Aydoğdu on 14.06.2025.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    // uygulama ilk kez açıldığında çalışır. gerekli başlatmaları yapıyoruz.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // firebase sdk başlatma
        FirebaseApp.configure()

        // push notification ayarları
        UNUserNotificationCenter.current().delegate = self // gelen bildirimleri kontrol etmek için
        Messaging.messaging().delegate = self // push token işlemleri için

        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print("Notification permission granted: \(granted)")
        }

        application.registerForRemoteNotifications() // sistemden push notification alma isteği

        return true
    }

    // MARK: - Firebase Messaging
    // push token alma, delegate yönetimi
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken ?? "nil")")
    }

    // uygulama foreground'da iken bile bildirim gelme ayarı
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}



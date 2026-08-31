//
//  DontForgetApp.swift
//  DontForget
//
//  Created by 제나 on 1/17/24.
//

import SwiftUI
import UserNotifications

@main
struct DontForgetApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        /// 서버 푸시가 없으므로 권한을 받은 뒤 저장된 기념일의 알림을 직접 예약합니다.
        Task {
            await LocalNotificationService.shared.requestAuthorization()
            await LocalNotificationService.shared.rescheduleAll()
        }

        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        print("=== DEBUG: willPresent: userInfo: ", userInfo)
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("=== DEBUG: didReceive: userInfo: ", userInfo)
        completionHandler()
    }
}

//
//  RS_DriverApp.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import SwiftUI
import UserNotifications
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if let firebaseToken = Messaging.messaging().fcmToken {
            updateFirebaseToken(firebaseToken)
        }
        
        LocationManager.shared.start()
        
        return true
    }
    
    func processNotification(_ userInfo: [AnyHashable : Any], fromBackground: Bool = false) {
        
        guard let aps = userInfo["aps"] as? NSDictionary else { return }
        //guard let idItem = userInfo["gcm.notification.id"] as? String else { return }
        guard let category = aps["category"] as? String else { return }
    
        if fromBackground {
            if category == "challenge" {
                NotificationManager.shared.selectedTab = 1
                NotificationManager.shared.refreshChallenge = true
            }
        }
    }
    
    func updateFirebaseToken(_ token: String) {
        let vm = AccountViewModel()
        vm.updateFirebaseToken(token)
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirebaseToken(fcmToken!)
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {

    // tato funkcia sa zavola ak je aplikacia spustena
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
        self.processNotification(notification.request.content.userInfo, fromBackground: false)
    }
    
    // tato funkcia sa zavola, ak sa aplikacia spusti pomocou notifikacie
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        self.processNotification(response.notification.request.content.userInfo, fromBackground: true)
        completionHandler()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }
}

@main
struct RS_DriverApp: App {
    
    @StateObject var routerViewModel = RouterViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RouterView().environmentObject(routerViewModel)
        }
    }
}

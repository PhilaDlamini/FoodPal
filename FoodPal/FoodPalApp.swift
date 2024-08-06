//
//  FoodPalApp.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import Firebase
import FirebaseMessaging


class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        //configure firebase
        FirebaseApp.configure()

        //set up FCM messaging
        Messaging.messaging().delegate = self

        //set up notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
        options: [.alert, .badge, .sound],
        completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()

        return true
    }
    
    //With method swizzling disabled, need to explicitly map apns token to fcm registration token
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.banner, .list, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(
            name: Notification.Name("didReceiveRemoteNotification"), object: nil,
            userInfo: userInfo
        )
        completionHandler()
    }
    
   
}

extension AppDelegate: MessagingDelegate {
    
    //called at each app startup and whenever a new token is generated
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            
            //save token to database 
            print("Attemping to load account data in FoodPalApp")
            if let acc: Account = Account.loadFromDefaults(key: "account") {
                Database.database().reference().child("users/\(acc.uid)/token").setValue(token)
                print("Token saved to database")
            }
            
            //Also save token to user defaults
            String.saveToDefaults(model: token, key: "token")
            print("Saved token to user defaults")
           
        } else {
            print("huh? \(String(describing: fcmToken))")
        }
    }

}

@main
struct FoodPalApp: App {
    //register app delegate for firebase app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}

/*
 
 Notifications to do:
 - When a post is claimed,
    unclaimed,
    picked up
 - Recurring 'make a post' notifications (done)
 */

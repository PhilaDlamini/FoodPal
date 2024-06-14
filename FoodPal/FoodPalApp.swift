//
//  FoodPalApp.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    return true
  }
}


@main
struct FoodPalApp: App {
    //register app delegate for firebase app
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Claimed(post: Post(id: UUID(), userPicURL: URL(string: "https://www.hackingwithswift.com/img/home-supercharge-your-skills-2@2x.jpg")!, userHandle: "@what", uid: "haha", title: "Pizza", description: "Bought this from dominos. We don't think it makes sense to keep it as nobody wants to eat it in our house. Please come grab it from us", expiryDate: Date.now, latitude: 234, longitude: -233, images: [URL(string: "https://www.hackingwithswift.com/img/home-supercharge-your-skills-2@2x.jpg")!, URL(string: "https://www.hackingwithswift.com/img/home-start-learning-2@2x.jpg")!, URL(string: "https://www.hackingwithswift.com/img/home-build-your-career-3@2x.jpg")!]))
        }
    }
}

//
//  Test.swift
//  FoodPal
//
//  Created by Phila Dlamini on 7/23/24.
//

import SwiftUI

struct Test: View {
//    let notificationID = UUID().uuidString
//    let notifCenter = UNUserNotificationCenter.current()

    var body: some View {
        VStack {
            Button("Send") {
                scheduleNotification()
                print("sheduled notif")
            }
        }
            .onAppear {
                requestNotificationPermissions()
//                scheduleNotification()
            }
    }
    
    func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) {success, error in
            if success {
                print("All set!")
            } else if error != nil {
                print("Error gaining notification access")
            }
        }
    }
    
    func scheduleNotification() {
        
        //remove any prev notifs
     //   notifCenter.removePendingNotificationRequests(withIdentifiers: [notificationID])
        
        //schedule a new one
        let content = UNMutableNotificationContent()
        content.title = "Got extra food?"
        content.subtitle = "Make someone's day by sharing"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        //schedule it
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
                print("A definite error \(error.localizedDescription)")
            }
        }
        
    }
}

#Preview {
    Test()
}

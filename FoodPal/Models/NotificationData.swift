//
//  ClaimedNotification.swift
//  Notification data to post to firebase when sending notifications
//
//  Created by Phila Dlamini on 8/4/24.
//

import Foundation

struct NotificationData: Identifiable, Codable {
    var id = UUID()
    var userHandle: String
    var title: String
    var token: String
}

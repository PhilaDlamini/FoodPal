//
//  Post.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import Foundation
import CoreLocation
 
 struct Post: Identifiable, Codable {
     var id: UUID // the post id
     var userPicURL: URL //for ease, TODO: issue -- what happens if the user updates thier info after this post was sent out?
     var userHandle: String //for ease
     var uid: String
     var title: String
     var description: String
     var expiryDate: Date
     var latitude: Double
     var longitude: Double
     var images: [URL]
     
     var isExpired: Bool {
         let diff = abs(expiryDate.timeIntervalSinceNow)
         return diff > 24 * 60 * 60
     }
     
     var expiryDateText: String {
         let formatter = DateFormatter()
         formatter.setLocalizedDateFormatFromTemplate("Md") // This will localize to "M/d", "d/M", etc. based on locale
         return formatter.string(from: expiryDate)
     }
     
     var expiryDateSpelledOut: String {
         let formatter = DateFormatter()
         formatter.setLocalizedDateFormatFromTemplate("MMMM dd") 
         return formatter.string(from: expiryDate)
     }
     
     func isFrom(account: Account) -> Bool {
         return account.uid == uid
     }
     
     func getDistance(from location: CLLocation) -> String {
         let formatter = NumberFormatter()
         formatter.usesSignificantDigits = false
         let distance = location.distance(from: CLLocation(latitude: latitude, longitude: longitude)) / 1000
         let number = NSNumber(value: distance)
         return "\(formatter.string(for: number)!) km"
        
     }
 }


//
//  Post.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import Foundation
 
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
     
     var distance: String {
         return "1 m"
     }
     
     var expiryDateText: String {
         let formatter = DateFormatter()
         //formatter.dateFormat = "MMMM dd"
         formatter.dateStyle = .short
         formatter.timeStyle = .none
         return formatter.string(from: expiryDate)
        
     }
 }
 

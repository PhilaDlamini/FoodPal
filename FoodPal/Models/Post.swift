//
//  Post.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import Foundation
 
 struct Post: Identifiable, Codable {
     var id: UUID // the post id 
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
     
     var userHandle: String {
         return "@what"
     }
 }
 

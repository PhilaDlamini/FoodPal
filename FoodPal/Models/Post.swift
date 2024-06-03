//
//  Post.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import Foundation

struct Post: Hashable {
    var title: String
    var userHandle: String 
    var distance: String //TODO: change to pickup location cods 
    var description: String
    var pictures: [String] //TODO: change
    var expiryDate: String //TODO: Change 
}

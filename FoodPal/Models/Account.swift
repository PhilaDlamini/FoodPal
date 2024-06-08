//
//  Account.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/2/24.
//

import Foundation

struct Account: Hashable, Codable {
    var fullName: String
    var email: String
    var handle: String
    var bio: String
    var timesDonated: Int
    var picURL: URL 
}

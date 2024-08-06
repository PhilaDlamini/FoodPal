//
//  Account.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/2/24.
//

import Foundation

class Account: Codable, ObservableObject {
    var fullName: String
    var email: String
    var handle: String
    var bio: String
    var timesDonated: Int
    var picURL: URL 
    var uid: String
    var token: String
    
    init() {
        self.fullName = "undefined"
        self.email = "undefined"
        self.handle = "undefined"
        self.bio = "undefined"
        self.timesDonated = -1
        self.picURL = URL(string: "https://www.hackingwithswift.com/img/home-start-learning-2@2x.jpg")!
        self.uid = "undefined"
        self.token = "undefined"
    }
    
    init(fullName: String, email: String, handle: String, bio: String, timesDonated: Int, picURL: URL, uid: String, token: String) {
        self.fullName = fullName
        self.email = email
        self.handle = handle
        self.bio = bio
        self.timesDonated = timesDonated
        self.picURL = picURL
        self.uid = uid
        self.token = "nil"
    }
    
    func update(to account:Account) {
        self.fullName = account.fullName
        self.email = account.email
        self.handle = account.handle
        self.bio = account.bio
        self.timesDonated = account.timesDonated
        self.picURL = account.picURL
        self.uid = account.uid
        self.token = account.token
    }
    
    //loads an the account from user defaults
   /* static func loadFromDefaults() -> Account? {
        if let accountData = UserDefaults.standard.data(forKey: "account") {
            if let account = try? JSONDecoder().decode(Account.self, from: accountData) {
                return account

            } else {
                print("Failed to decode account from defaults")
            }
            
        } else {
            print("Failed to load account data from defaults")
        }
        
        return nil
    }
    
    //saves the account to defaults
    func saveToDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "account")
            print("Saved account data to user defaults")
        } else {
            print("Failed to save account data to defaults")
        }
    }*/
}

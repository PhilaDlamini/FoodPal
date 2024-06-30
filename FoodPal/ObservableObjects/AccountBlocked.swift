//
//  AccountBlocked.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/30/24.
//

import Foundation

class AccountBlocked: ObservableObject {
    @Published var blocked: Bool
    @Published var accountHandle: String
    
    init() {
        self.blocked = false
        self.accountHandle = ""
    }
}

//
//  Blocked.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/29/24.
//

import Foundation

class BlockedAccounts: ObservableObject {
    @Published var blocked: Set<String>

    init() {
        self.blocked = []
    }
}

//
//  PostUnavailable.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/29/24.
//

import Foundation

class PostUnavailable: ObservableObject {
    @Published var unavailable: Bool
    
    init() {
        self.unavailable = false
    }
}

//
//  PostUnavailable.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/29/24.
//

import Foundation

class PostReported: ObservableObject {
    @Published var reported: Bool
    
    init() {
        self.reported = false
    }
}

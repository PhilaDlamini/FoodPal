//
//  AccountProfilePic.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/25/24.
//

import SwiftUI

import Foundation
import SwiftUI

class AccountPic: ObservableObject {
    @Published var image: Image?
    init() {
        self.image = nil
    }
}

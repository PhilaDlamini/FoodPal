//
//  ProfilePic.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/16/24.
//

import Foundation
import SwiftUI

class PostProfilePic: ObservableObject {
    @Published var image: Image?
    init() {
        self.image = nil
    }
}

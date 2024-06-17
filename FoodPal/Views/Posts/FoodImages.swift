//
//  FoodImage.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/16/24.
//

import Foundation
import SwiftUI

class FoodImages: ObservableObject {
    @Published var images: [String: Image]?
    init() {
        self.images = nil
    }
}


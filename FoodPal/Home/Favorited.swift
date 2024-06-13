//
//  Favorites.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation

class Favorited: ObservableObject {
    @Published var favorited: [String]
    
    init() {
        self.favorited = []
    }
    
    func update(to updated: [String]) {
        self.favorited = updated
    }
    
    func add(fav: String) {
        if !favorited.contains(where: {$0 == fav}) {
            favorited.append(fav)
        }
    }
    
    func remove(fav: String) {
        favorited.removeAll(where: {$0 == fav})
    }
}

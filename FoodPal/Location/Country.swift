//
//  Country.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/22/24.
//

import Foundation


//A country as it appears in Search
struct Country: Codable {
    let name: String
    let emoji: String
    let states: [Region]
}

//A region (state/province) inside a country
struct Region: Codable {
    let name: String
    let state_code: String
    let cities: [City]
}

//A city inside a region
struct City: Codable {
    let name: String
}

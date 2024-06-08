//
//  CodableExtension.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/8/24.
//

import Foundation

func toDict <T: Codable> (model: T) -> NSDictionary? {
    let encoder = JSONEncoder()
    
    do {
        let data = try encoder.encode(model)
        
        if let jsonObject = try JSONSerialization.jsonObject(with: data) as? NSDictionary {
            return jsonObject
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    return nil
}

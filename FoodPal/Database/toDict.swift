//
//  CodableExtension.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/8/24.
//

import Foundation

//TODO: make this an extension of encodable 
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

extension Decodable {
    static func fromDict<T:Decodable> (dictionary: [String: Any]) throws -> T {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            let obj = try decoder.decode(T.self, from: jsonData)
            return obj
    }
    
    static func loadFromDefaults <T: Decodable> (key: String) -> T? {
        if let jsonData = UserDefaults.standard.data(forKey: key) {
            if let obj = try? JSONDecoder().decode(T.self, from: jsonData) {
                return obj

            } else {
                print("Failed to decode \(key) from defaults")
            }
            
        } else {
            print("Failed to load \(key) data from defaults")
        }
        
        return nil
    }
}

extension Encodable {
    static func saveToDefaults <T: Encodable> (model: T, key: String) {
        if let encoded = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(encoded, forKey: key)
            print("Saved account data to user defaults")
        } else {
            print("Failed to save account data to defaults")
        }
    }
}

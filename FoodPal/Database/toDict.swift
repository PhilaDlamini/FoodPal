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
}

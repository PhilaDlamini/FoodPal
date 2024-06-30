//
//  Address.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation
import MapKit

let flagMap = [
    "United States" : "🇺🇸",
    "South Africa" : "🇿🇦"
]


class Address: ObservableObject, Identifiable {
    var id = UUID()
    @Published var num: String
    @Published var street: String
    @Published var city: String
    @Published var state: String
    @Published var country: String
    
     init() {
        self.num = ""
        self.street = ""
        self.city = ""
        self.state = ""
        self.country = ""
    }
    
    init(num: String, street: String, city: String, region: String, country: String) {
        self.num = num
        self.street = street
        self.city = city
        self.state = region
        self.country = country
    }
    
    func isValid() -> Bool {
        return !(city.isEmpty || state.isEmpty || country.isEmpty)
    }
    
    func update(to address: Address) {
        self.num = address.num
        self.street = address.street
        self.city = address.city
        self.state = address.state
        self.country = address.country
    }
    
    func getString() -> String {
        return "\(num) \(street) \(city) \(state) \(country)"
    }
    
    func getStreetAddress() -> String {
        var ret = ""
        if !num.isEmpty {
            ret.append("\(num) ")
        }
        
        if !street.isEmpty {
            ret.append("\(street) ")
        }
        
        if !city.isEmpty {
            ret.append("\(city) ")
        }
        
        if ret.isEmpty {
            return "- - -"
        }
        
        return ret
        
    }
    
    func getStateAndCountry() -> String {
        var ret = ""
        if !state.isEmpty {
            ret.append("\(state) ")
        }
        
        if !country.isEmpty {
            ret.append("\(country) ")
        }
        
        if ret.isEmpty {
            return "- -"
        }
        
        return ret
        
    }
}

//Get address for given CLLocation
func getAddress(for location: CLLocation, completion: @escaping (Address) -> Void)  {
    CLGeocoder().reverseGeocodeLocation(location) {placemarks, _ in
        guard let placemark = placemarks?.first else { completion(Address()); return }
        let num = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let city = placemark.locality ?? ""
        let region = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""
        completion(Address(num: num, street: street, city: city, region: region, country: country))
    }
}

//Get address for given MKMapItem
func getAddress(for mapItem: MKMapItem) -> String {
    let placemark = mapItem.placemark
    let num = placemark.subThoroughfare ?? ""
    let street = placemark.thoroughfare ?? ""
    let state = placemark.administrativeArea ?? ""
    let city = placemark.locality ?? ""
    return "\(num) \(street) \(city) \(state)"
}

//
//  Address.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation
import MapKit

class Address: ObservableObject {
    @Published var num: String
    @Published var street: String
    @Published var city: String
    @Published var region: String
    @Published var country: String
    
     init() {
        self.num = ""
        self.street = ""
        self.city = ""
        self.region = ""
        self.country = ""
    }
    
    init(num: String, street: String, city: String, region: String, country: String) {
        self.num = num
        self.street = street
        self.city = city
        self.region = region
        self.country = country
    }
    
    func update(to address: Address) {
        self.num = address.num
        self.street = address.street
        self.city = address.city
        self.region = address.region
        self.country = address.country
    }
    
    func getString() -> String {
        return "\(num) \(street) \(city) \(region) \(country)"
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

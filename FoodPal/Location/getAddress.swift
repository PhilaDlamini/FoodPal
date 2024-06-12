//
//  getAddress.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/11/24.
//

import Foundation
import CoreLocation
import MapKit

//Get address for given CLLocation
func getAddress(for location: CLLocation, completion: @escaping (String) -> Void )  {
    CLGeocoder().reverseGeocodeLocation(location) {placemarks, _ in
        guard let placemark = placemarks?.first else { completion(""); return}
        let num = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let state = placemark.administrativeArea ?? ""
        let city = placemark.locality ?? ""
        completion("\(num) \(street) \(city) \(state)")
    }
}

//Get the city, region, and country for a CLLocation
func getCityRegionAndCountry(latitude: Double, longitute: Double, completion: @escaping (String, String, String) -> Void )  {
    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitute)) {placemarks, _ in
        guard let placemark = placemarks?.first else { completion("", "", ""); return}
        let city = placemark.locality ?? ""
        let region = placemark.administrativeArea ?? ""
        let country = placemark.country ?? ""
        completion(city, region, country)
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

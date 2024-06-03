//
//  LocationManager.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/1/24.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var mapItem: MKMapItem?
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.location = location
                self.mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)))
            }
            //Stop updating to save battery life 
            locationManager.stopUpdatingLocation()
        }
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}

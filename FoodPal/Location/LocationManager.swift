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

    //These are optional since the user could turn off location services at any point
    @Published var location: CLLocation?
    @Published var status: CLAuthorizationStatus?
    @Published var usingDefaultLocation: Bool = false

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //when authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
            self.usingDefaultLocation = false

        case .denied, .restricted:
            // User has denied permission - fallback to NYC
            self.usingDefaultLocation = true
            self.location = CLLocation(latitude: 40.713019, longitude: -74.013179)

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latestLocation = locations.last {
            self.location = latestLocation
            self.usingDefaultLocation = false
        }
    }


    // Called when there's a failure with an error --> fallback to NYC too
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        
        // Fallback here too
        self.usingDefaultLocation = true
        self.location = CLLocation(latitude: 40.713019, longitude: -74.013179)
        print("Defaulted to NYC location")
    }

}

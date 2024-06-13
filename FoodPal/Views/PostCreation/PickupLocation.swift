//
//  PickupLocation.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/6/24.
//

import SwiftUI
import MapKit

struct LocationSearch: View {
    @Environment(\.dismiss) var dismiss
    @Binding var usingAlternateLocation: Bool
    @Binding var alternateLocation: CLLocation?
    @State var searchResults: [MKMapItem] = []
    @State var searchText = ""
    
    
    //TODO: make map show currently selected location on the pin
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search locations", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }
                .padding(5)
                
                Button("Search") {
                    search(query: searchText)
                }
            }
            .padding()
            
            List {
                ForEach(searchResults, id: \.self) {mapItem in
                    Text("\(getAddress(for: mapItem))")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            usingAlternateLocation = true
                            let cod = mapItem.placemark.coordinate
                            alternateLocation = CLLocation(latitude: cod.latitude, longitude: cod.longitude)
                            dismiss()
                        }
                }
            }
        }
    }
    
    func search(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}


struct PickupLocation: View {
    @Binding var latitude: Double
    @Binding var longitude: Double
    @State var showLocationPicker = false
    @State var usingAlternateLocation = false
    @State var alternateLocation: CLLocation? = nil
    @State var address: String = ""
    @State var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    @StateObject private var locationManager = LocationManager()
    
    //The pickup location
     var pickUpLocation: CLLocation? {
         if usingAlternateLocation {
             return alternateLocation
         }
         return locationManager.location
    }
    
    var body: some View {
        if locationManager.status == .denied || locationManager.status == .restricted {
            Text("Location services not available. Change in settings")
        } else {
            VStack {
                VStack (alignment: .leading) {
                    Text("Pickup location:")
                        .font(.headline)
                        .bold()
                    
                    Text("\(address)")
                        .font(.caption)
                    
                }
                
                if let location = pickUpLocation {
                    Map(position: $position) {
                        Marker("", coordinate: location.coordinate)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(height: 400)
                }
                
                if usingAlternateLocation {
                    Button("Use current location") {
                        usingAlternateLocation = false
                    }
                } else {
                    Button("Use alternate location") {
                        showLocationPicker = true
                    }
                }
                
            }
            .onChange(of: pickUpLocation) { _ , _ in
                
                //update camera position and get new address
                if let location = pickUpLocation {
                    position = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                    getAddress(for: location) {updatedAddress in
                        address = updatedAddress.getString()
                    }
                    latitude = location.coordinate.latitude
                    longitude = location.coordinate.longitude
                } else {
                    address = ""
                }
            }
            .sheet(isPresented: $showLocationPicker) {
                LocationSearch(usingAlternateLocation: $usingAlternateLocation, alternateLocation: $alternateLocation)
            }
            .padding()
        }
    }
  
}
    

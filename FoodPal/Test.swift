//
//  SwiftUIView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/15/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct Test: View {
    @State var searchText = ""
    @State var address = ""
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State var addressResults = [Address]()
    @State var locationResults = [MKMapItem]()
    @State var showLocationPicker = false
    @State var usingAlternateLocation = false
    @State var alternateLocation: CLLocation? = nil
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
        NavigationView {
            if let location = pickUpLocation {
                ScrollView (.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Pickup location:")
                                    .font(.headline)
                                    .bold()
                                
                                Text("\(address)")
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            if usingAlternateLocation {
                                Image(systemName: "")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        usingAlternateLocation.toggle()
                                    }
                            }
                        }
                        
                        ForEach(0..<addressResults.count, id: \.self) {index in
                            let address = addressResults[index]
                            
                            VStack(alignment: .leading) {
                                Text("\(flagMap[address.country]!) \(address.num) \(address.street)")
                                    .font(.headline)
                                Text("\(address.city), \(address.region)")
                                    .font(.caption)
                            }
                            .onTapGesture {
                                //  showResults = true
                                let cod = locationResults[index].placemark.coordinate
                                alternateLocation = CLLocation(latitude: cod.latitude, longitude: cod.longitude)
                                usingAlternateLocation.toggle()
                            }
                        }
                        
                        Map(position: $position) {
                            Marker("", coordinate: location.coordinate)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 400)
                    }
                    .searchable(text: $searchText)
                    .onSubmit(of: .search) {
                        search(query: searchText)
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
                }
                .padding()
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
            locationResults = response?.mapItems ?? []
        }
    }
   
}

//TODO: write in ios notes -- how to get only the data you want from a json object 

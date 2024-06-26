//
//  SwiftUIView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/15/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationSearch: View {
    @Binding var addressResults: [Address]
    @Binding var locationResults: [MKMapItem]
    @Binding var usingAlternateLocation: Bool
    @Binding var alternateLocation: CLLocation?
    @State var searchText = ""
    @Binding var showSheet: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<addressResults.count, id: \.self) {index in
                    let address = addressResults[index]
                    
                    VStack(alignment: .leading) {
                        Text("\(flagMap[address.country]!) \(address.num) \(address.street)")
                            .font(.headline)
                        Text("\(address.city), \(address.state)")
                            .font(.caption)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let cod = locationResults[index].placemark.coordinate
                        alternateLocation = CLLocation(latitude: cod.latitude, longitude: cod.longitude)
                        usingAlternateLocation.toggle()
                        showSheet = false
                    }
                }
                
            }
            .padding(.top, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            dismiss()
                        }
                }
                
            }
            .navigationTitle("Search Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
            .onSubmit(of: .search) {
                search(query: searchText)
            }
        }
    }
    
    func search(query: String) {
        print("Started search ")
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            locationResults = response?.mapItems ?? []
            addressResults = []
            for res in locationResults {
                let cod = res.placemark.coordinate
                getAddress(for: CLLocation(latitude: cod.latitude, longitude: cod.longitude)) {add in
                    addressResults.append(add)
                }
            }
            print("Completed search with \(locationResults.count) results")
        }
    }
}

struct PickupLocation: View {
    @State var searchText = ""
    @State var streetAddress = ""
    @Binding var latitude: Double
    @Binding var longitude: Double
    @State var addressResults = [Address]()
    @State var locationResults = [MKMapItem]()
    @State var showLocationPicker = false
    @State var usingAlternateLocation = false
    @State var alternateLocation: CLLocation? = nil
    @State var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    @StateObject private var locationManager = LocationManager()
    @State var showSheet = false
    
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
                VStack(alignment: .leading) {
                    
                    Map(position: $position) {
                        Marker("", coordinate: location.coordinate)
                    }
                    .frame(height: 500)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Pickup location:")
                                .font(.headline)
                                .bold()
                            
                            Text("\(streetAddress)")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        HStack(alignment: .center, spacing: 10) {
                            if usingAlternateLocation {
                                Image(systemName: "location.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                                    .onTapGesture {
                                        usingAlternateLocation.toggle()
                                    }
                            }
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .onTapGesture {
                                    showSheet = true
                                }
                        }
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                }
                .sheet(isPresented: $showSheet) {
                    LocationSearch(addressResults: $addressResults, locationResults: $locationResults, usingAlternateLocation: $usingAlternateLocation, alternateLocation: $alternateLocation, showSheet: $showSheet)
                }
                .onChange(of: pickUpLocation) { _,_ in
                    
                    //update camera position and get new address
                    if let location = pickUpLocation {
                        position = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        getAddress(for: location) {updatedAddress in
                            streetAddress = updatedAddress.getStreetAddress()
                        }
                        latitude = location.coordinate.latitude
                        longitude = location.coordinate.longitude
                    } else {
                        streetAddress = ""
                    }
                }
            }
        }
        
    }
}

//TODO: separate address into two lines, (street address, (then on next line) state, country 

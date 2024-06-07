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
    @State var searchResults = ["43 Wintrop St", "124th E st", "21 Front St", "100 Packard Ave",
                                "123 CityTown St, Somerville", "34 Tesla Ave, Medford"]
    @State var searchText = ""
    
    
    //TODO: make map show currently selected location on the pin 
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("", text: $searchText, prompt: Text("Search locations").foregroundStyle(.gray))
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }
                .padding(5)
                .background(.white)
                .cornerRadius(5)
                
                Button("Cancel") {
                    dismiss()
                }
            }
            .padding()
            
            List {
                ForEach(searchResults, id: \.self) { res in
                    Text("\(res)")
                        .contentShape(Rectangle())
                        .onTapGesture {
                            usingAlternateLocation = true
                            alternateLocation = CLLocation(latitude: 10, longitude: -20)
                            dismiss()
                        }
                }
            }
        }
    }
}

struct PickupLocation: View {
    @State var searching = false
    @State var usingAlternateLocation = false
    @State var alternateLocation: CLLocation?
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack (spacing: 15) {
            
            HStack {
                VStack (alignment: .leading) {
                    Text("Pickup location:")
                        .font(.headline)
                        .bold()
                    
                    if usingAlternateLocation {
                        if let alternateLocation = alternateLocation {
                            Text("\(getAddress(for: MKMapItem(placemark: MKPlacemark(coordinate: alternateLocation.coordinate))))")
                                .font(.caption)
                        } else {
                            Text("No alternate location")
                                .font(.caption)
                        }
                    } else {
                        
                        if let location = locationManager.location {
                            Text("\(getAddress(for: MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))))")
                                .font(.caption)
                        } else {
                            Text("Current location not found")
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    searching = true
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            ZStack (alignment: .bottomTrailing) {
                Map {
                    if usingAlternateLocation {
                        if let alternateLocation = alternateLocation {
                            Marker(item: MKMapItem(placemark: MKPlacemark(coordinate: alternateLocation.coordinate)))
                        }
                    } else {
                        if let location = locationManager.location {
                            Marker(item: MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate)))
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 400)
                
                if usingAlternateLocation {
                    Image(systemName: "dot.scope")
                        .onTapGesture {
                            usingAlternateLocation = false
                            alternateLocation = nil
                        }
                        .padding()
                }
            }
            
        }
        .sheet(isPresented: $searching) {
            LocationSearch(usingAlternateLocation: $usingAlternateLocation, alternateLocation: $alternateLocation)
        }
        .padding()
    }
    
    //Searches for the address given by the user
    func search (for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            // searchResults = response?.mapItems ?? []
        }
    }
    
    //Returns the address from an MKMapItem
    func getAddress(for mapItem: MKMapItem) -> String {
        let placemark = mapItem.placemark
        let num = placemark.subThoroughfare ?? ""
        let street = placemark.thoroughfare ?? ""
        let state = placemark.administrativeArea ?? ""
        let city = placemark.locality ?? ""
        let country = placemark.country ?? ""
        let code = placemark.postalCode ?? ""
        return "\(num) \(street), \(city), \(state) \(code), \(country)"
    }
}
    

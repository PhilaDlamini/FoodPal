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
    @Binding var pickedLocation: String
    @State var searchResults = ["43 Wintrop St", "124th E st", "21 Front St", "100 Packard Ave",
                                "123 CityTown St, Somerville", "34 Tesla Ave, Medford"]
    @State var searchText = ""
    
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
                        .onTapGesture {
                            pickedLocation = res
                            dismiss()
                        }
                }
            }
        }
    }
}

struct PickupLocation: View {
    //    @State var searchResults = [MKMapItem]()
   
    @State var pickedLocation = "43 Winthrop St"
    @State var searching = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                VStack (alignment: .leading) {
                    Text("Pickup location:")
                        .font(.headline)
                        .bold()
                    Text("\(pickedLocation)")
                        .font(.caption)
                }
                
                Spacer()
                
                Button(action: {
                    searching = true
                }) {
                    Image(systemName: "magnifyingglass")
                }
            }
            
            Map {
                //Add mark
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(height: 400)
            
        }
        .sheet(isPresented: $searching) {
            LocationSearch(pickedLocation: $pickedLocation)
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
    

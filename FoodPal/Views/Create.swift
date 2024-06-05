//
//  Create.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/30/24.
//

import SwiftUI
import MapKit


//The form for basic info
struct FoodDetails: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var expiryDate: Date
    
    var body: some View {
        Form  {
            TextField("Title", text: $title)
            
            Section(header: Text("Description")) {
                TextEditor(text: $description)
            }
            
            Section {
                DatePicker("Expiry date", selection: $expiryDate, displayedComponents: .date)
                Text("The earliest expiry date of an item in your donation")
                    .font(.caption)
            }
            
        }
    }
}


struct FoodPictures: View {
    @State var showImagePicker = false
    @Binding var images: [UIImage]
    
    var body: some View {
        
        
        VStack {
                
                VStack (alignment: .leading) {
                    
                    if images.count > 0 {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(images, id: \.self) {pic in
                                        Image(uiImage: pic)
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .frame(width: 200, height: 400)
                                    }
                                }
                            }
                            .frame(height: 410)
                            .scrollIndicators(.hidden)
                            
                            Text("At least 3 pictures required")
                                .foregroundStyle(.gray)
                                .font(.caption)
                            
                        }
                    } else {
                        HStack {
                            Spacer()
                            VStack (alignment: .center, spacing: 10) {
                                Spacer()
                                Image(systemName: "mug")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                
                                Text("Share food pictures")
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showImagePicker = true
                        }) {
                            Circle()
                                .fill(.white)
                                .stroke(.black, lineWidth: 10)
                                .stroke(.white, lineWidth: 3)
                                .frame(width: 60)
                            
                        }
                        
                        Spacer()
                    }
                    
                    
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(images: $images, isPickerShowing: $showImagePicker)
                }
                .padding()
            }
        }
    }

struct PickupLocation: View {
//    @State var searchResults = [MKMapItem]()
    @State var searchResults = ["43 Wintrop St", "124th E st", "21 Front St", "100 Packard Ave",
    "123 CityTown St, Somerville", "34 Tesla Ave, Medford"]
    @State var searchText = ""
    @State var pickedLocation = "43 Winthrop St"
    @State var searching = false
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        
      
        return ZStack (alignment: .bottom) {
            
            Map {
//                if let location = locationManager.mapItem {
//                    Marker(item: location)
//                }
            }
           
            if searching {
                ScrollView(.vertical) {
                    HStack {
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("", text: $searchText, prompt: Text("Search locations").foregroundStyle(.black))
                        }
                        .padding()
                        .background(Color(red: 28, green: 27, blue: 27, opacity: 1)) //TODO: seems to not apply
                        .cornerRadius(25)
                    
                        Button("Cancel") {
                            searching = false
                        }
                    }
                    
                    LazyVStack{
                        ForEach(searchResults, id: \.self) {res in
                            VStack (alignment: .leading) {
                                
                                HStack {
                                    Text("\(res)")
                                        .padding(5)
                                    Spacer()
                                }
                                Divider()
                            }
                            .onTapGesture {
                                searching = false
                                pickedLocation = res
                            }
                        }
                    }
                }
                .padding()
                .background(.white, in:
                    RoundedRectangle(cornerRadius: 25.0))
                .padding()
                .frame(height: 400)
            } else {
                HStack (alignment: .center) {
                    VStack (alignment: .leading) {
                      Text("Pickup location")
                          .font(.headline)
                      Text("\(pickedLocation)")

                   }
                   
                   Spacer()
                   
                   Button(action: {
                       searching = true
                   }) {
                       Image(systemName: "magnifyingglass")
                           .foregroundStyle(.black)
                           .bold()
                   }
               }
               .padding()
               .background(.white, in:
                   RoundedRectangle(cornerRadius: 25.0))
               .padding()
            }
            
        }
        .foregroundColor(.black)
        
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

struct Create: View {
    @State var title = ""
    @State var description = ""
    @State var expiryDate = Date.now
    @State private var currView = 1 //The current view to show the user
    @State private var nextText = "Next"
    @State var images = [UIImage]()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
               
        NavigationView {
            VStack {
                switch currView {
                case 1: 
                    FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                    
                case 2:
                    FoodPictures(images: $images)
                
                case 3:
                    PickupLocation()
                    
                default:
                    FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("\(nextText)") {
                        if currView == 1 {
                            currView = 2
                        } else if currView == 2 {
                            nextText = "Done"
                            currView = 3
                        } else {
                            //finish
                            post()
                            dismiss()
                        }
                    }
                    .disabled(currView == 2 && images.count < 3)
                }
            }
        }
    }
    
    func post() {
        //Post the post to city's database
    }
}



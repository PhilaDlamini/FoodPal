//
//  PostInfo.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import MapKit

//TODO: add map to see pickup location and current user location
struct PostInfo: View {
    var post: Post
    @State var showExpiryDateInfo = false
    @EnvironmentObject var address: Address
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 15) {
                Text("\(post.description)")
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack { //creates views as needed, not all at once
                        ForEach(post.images, id: \.self) {img in
                            
                            AsyncImage(url: img) {phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } else if phase.error != nil {
                                    Color.red
                                } else {
                                    ProgressView()
                                }
                            }
                            .frame(width: 200, height: 400)
                            .cornerRadius(25)
                        }
                    }
                }
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Pickup location:")
                            .font(.headline)
                            .bold()
                        Text("\(address.getString())")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center, spacing: 5) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(post.distance) away")
                            .font(.caption)
                    }
                }
                
                Map {
                    Marker("", coordinate: CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude))
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 400)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Expiry date:")
                            .font(.headline)
                            .bold()
                        Text("\(post.expiryDateText)")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showExpiryDateInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
        
                Divider()
                
                HStack {
                    
                    VStack (spacing: 10)  {
                        Button(action: {}) {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.white)
                                .padding()
                                .overlay(Circle().stroke(.white, lineWidth: 1))
                        }
                        
                        Text("Claim")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 10) {
                        Button(action: {}) {
                            Image(systemName: "star")
                                .foregroundColor(.white)
                                .padding()
                                .overlay(Circle().stroke(.white, lineWidth: 1))
                        }
                        
                        Text("Favorite")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack (spacing: 10) {
                        Button(action: {}) {
                            Image(systemName: "flag")
                                .foregroundColor(.white)
                                .padding()
                                .overlay(Circle().stroke(.white, lineWidth: 1))
                        }
                        
                        Text("Report")
                            .font(.caption)
                    }
                }
                
                Text("    \n ")
                
            }
           
        }
        .alert("Expiry date", isPresented: $showExpiryDateInfo) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("The is the earliest that a food item in the donation expires. At this date, this donation will be taken down")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                
                AsyncImage(url: post.userPicURL) {phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 25)
                .onTapGesture {
                    print("Going to account info from post info")
                }

                
                
            }
            
        }
        .padding()
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}


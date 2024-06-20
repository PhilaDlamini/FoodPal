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
    @State var address = ""
    @State var id = UUID()
    @State var imgId = UUID()
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var favorited: FavoritedPosts
    @EnvironmentObject var profile: ProfilePic
    @EnvironmentObject var foodImages: FoodImages
    @EnvironmentObject var account: Account
    @State var selectedImage: Image = Image(systemName: "")
    @State var showSelectedImage = false
    
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 15) {
                Text("\(post.description)")
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack { //creates views as needed, not all at once
                        
                        if (foodImages.images != nil) && (foodImages.images!.count == post.images.count) {
                            if let images = foodImages.images {
                                ForEach(Array(images.keys), id: \.self) {index in
                                    let image = images[index]!
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 260, height: 400)
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            selectedImage = image
                                            showSelectedImage = true
                                        }
                                        .fullScreenCover(isPresented: $showSelectedImage) {
                                            ViewImage(image: selectedImage)
                                        }
                                    
                                }
                            }
                        } else {
                            ForEach(post.images, id: \.self) {url in
                                
                                 AsyncImage(url: url) {phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 260, height: 400)
                                            .cornerRadius(20)
                                            .onTapGesture{
                                                selectedImage = image
                                                showSelectedImage = true
                                            }
                                            .fullScreenCover(isPresented: $showSelectedImage) {
                                                ViewImage(image: selectedImage)
                                            }
                                            
                                    } else if phase.error != nil {
                                        Color.red
                                            .onAppear {
                                                imgId = UUID()
                                            }//Retry loading the image here (other idea: try async again in the postView if the iamge was never retrieved
                                    } else {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.gray)
                                            .frame(width: 260, height: 400)
                                    }
                                }
                            }
                            .id(imgId)
                            
                        }
                    }
                }
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Pickup location:")
                            .font(.headline)
                            .bold()
                        Text("\(address)")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    VStack (alignment: .center, spacing: 5) {
                        Image(systemName: "mappin.and.ellipse")
                        Text("\(post.getDistance(from: locationManager.location!)) away")
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
                        Text("\(post.expiryDateSpelledOut)")
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
                    
                    Button(action: {
                        claim(account: account, post: post)
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "fork.knife")
                            Text("Claim")
                        }
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(25)
                    
                    Spacer()
                    
                        
                    if favorited.posts.contains(where: { key, value in value.id.uuidString == post.id.uuidString}) {
                        Button(action: {
                            favorite(account: account, post: post)
                        }) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .padding()
                        }
                    } else {
                        Button(action: {
                            unfavorite(account: account, post: post)
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                        
                       
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "flag")
                            .foregroundColor(.white)
                            .padding()
                    }
                        
    
                }
                
                Text("    \n ")
                
            }
           
        }
        .onAppear {
            getAddress(for: CLLocation(latitude: post.latitude, longitude: post.longitude)) {add in
                address = add.getString()
            }
        }
        .alert("Expiry date", isPresented: $showExpiryDateInfo) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("The is the earliest date that a food item in this post expires")
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                
                if let image = profile.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25)
                        .clipShape(Circle())
                        .onTapGesture {
                            print("Going to account info from post info")
                        }
                    
                } else {
                    AsyncImage(url: post.userPicURL) {phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 25)
                        } else if phase.error != nil {
                            Color.red
                                .onAppear {
                                    id = UUID()
                                }//Retry loading the image here (other idea: try async again in the postView if the iamge was never retrieved
                        } else {
                            Circle()
                                .fill(.gray)
                                .frame(width: 25)
                                
                        }
                    }
                    .id(id)
                }
            }
            
        }
        .padding()
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}


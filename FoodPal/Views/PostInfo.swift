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
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 15) {
                Text("\(post.description)")
                
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack { //creates views as needed, not all at once
                        ForEach(post.pictures, id: \.self) {img in
                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                .fill(.white)
                                .stroke(.black, lineWidth: 1)
                                .frame(width: 200, height: 400)
                        }
                    }
                }
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Pickup location:")
                            .font(.headline)
                            .bold()
                        Text("43 Winthrop St")
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
                    //Add mark
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 400)
                
                HStack {
                    VStack (alignment: .leading) {
                        Text("Expiry date:")
                            .font(.headline)
                            .bold()
                        Text("Aug 24th")
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
                
                //TODO: make into poster image
                Circle()
                    .fill(.gray)
                    .frame(width: 25)

                
                
            }
            
        }
        .padding()
        .navigationTitle("\(post.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PostInfo(post:  Post(title: "Veggies", userHandle: "@elias", distance: "1.8 mile", description: "Fresh vegetables from the store!", pictures: ["A", "B", "D"], expiryDate: "5/11"))
}

//
//  Claimed.swift
//  FoodPal
//  Created by Phila Dlamini on 6/14/24.
//

import SwiftUI
import FirebaseDatabase
import CoreLocation

struct Claimed: View {
    var post: Post
    @State var cancelClicked = false 
    @State var pickUpAddress = Address()
    @EnvironmentObject var account: Account
    let ref = Database.database().reference()
    @State var selectedImage: Image = Image(systemName: "")
    @State var showSelectedImage = false
    @State var imgId = UUID()
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 15) {
                    Text("\(post.title)")
                        .font(.headline)
                    Text("\(post.description)")
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack { //creates views as needed, not all at once
                            
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
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Pickup location:")
                                .font(.headline)
                                .bold()
                            Text("43 Winthrop St\(pickUpAddress.getString())")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("Directionss")
                                Image(systemName: "arrow.clockwise.square.fill")
                            }
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(20)
                    }
                    
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        Button("Confirm pickup") {
                            getAddress(for: CLLocation(latitude: post.latitude, longitude: post.longitude), completion: confirmPickUp)
                        }
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(25)
                        
                        Spacer()
                        
                    }
                    
                }
                .padding()
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("You claimed a post")
                        .font(.headline)
                        .bold()
                }
                ToolbarItem {
                    Button(action: {
                        cancelClicked = true
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .alert("Cancel pickup", isPresented: $cancelClicked) {
                Button("Ok", role: .cancel, action: cancelPickUp)
                Button("No", role: .destructive) {}
            } message: {
                Text("Are you sure you want to cancel this pickup?")
            }
        }
    }
    
    func cancelPickUp() {
        ref.child("claimed/\(account.uid)/\(post.id)").removeValue()
    }
    
    func confirmPickUp(address: Address) {
          
        //remove post from main post section
        ref.child("posts/\(address.country)/\(address.state)/\(address.city)/\(post.id)").removeValue()
        
        //remove post from user posts
        ref.child("user posts/\(account.uid)/\(post.id)").removeValue()
        
        //remove the post from favorites, if any
        ref.child("favorited/\(account.uid)/\(post.id)").removeValue()
        
        //remove the claimed post
        ref.child("claimed/\(account.uid)/\(post.id)").removeValue()

        
        
    }
}

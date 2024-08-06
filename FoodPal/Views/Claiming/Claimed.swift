//
//  Claimed.swift
//  FoodPal
//  Created by Phila Dlamini on 6/14/24.
//

import SwiftUI
import FirebaseDatabase
import CoreLocation
import FirebaseStorage

struct Claimed: View {
    var post: Post
    @State var cancelClicked = false 
    @State var claimingInProgress = false
    @State var pickUpAddress = ""
    @EnvironmentObject var account: Account
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
                                                ImageViewer(image: selectedImage)
                                            }
                                        
                                    } else if phase.error != nil {
                                        Color.red
                                            .onAppear {
                                                imgId = UUID()
                                            }
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
                            Text("\(pickUpAddress)")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "location.circle")
                            .font(.title2)
                            .onTapGesture {
                                let urlString = "http://maps.apple.com/?daddr=\(post.latitude),\(post.longitude)"
                                if let url = URL(string: urlString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    
                    
                    HStack () {
                        Spacer()
                        
                        Button("Confirm pickup") {
                            claimingInProgress = true
                            getAddress(for: CLLocation(latitude: post.latitude, longitude: post.longitude)) {address in
                                deletePost(post: post, account: account, address: address)
                                
                                //notify posting user this has been picked up
                                let ref = Database.database().reference()
                                ref.child("users/\(post.uid)/token").getData {error, snapshot in
                                    if let snapshot {
                                        if snapshot.value is String {
                                            let notif = NotificationData(userHandle: account.handle, title: post.title, token: snapshot.value as! String)
                                            let notifJson = toDict(model: notif)
                                            ref.child("notifications/picked/\(notif.id)").setValue(notifJson)
                                        }
                                    }
                                }
                            }
                        }
                        .disabled(claimingInProgress)
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(25)
                        
                        Spacer()
                        
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("Claimed post")
                        .font(.title)
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
            .onAppear {
                getAddress(for: CLLocation(latitude: post.latitude, longitude: post.longitude)) {
                    pickUpAddress = $0.getStreetAddress()
                }
            }
            .alert("Cancel pickup", isPresented: $cancelClicked) {
                Button("Yes", role: .cancel, action: {
                    cancelPickUp(post: post, account: account)
                })
                Button("No", role: .destructive) {}
            } message: {
                Text("Are you sure you want to cancel this pickup?")
            }
        }
    }

}


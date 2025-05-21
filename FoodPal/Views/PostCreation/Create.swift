//
//  Create.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/30/24.
//

import SwiftUI
import MapKit
import FirebaseStorage
import FirebaseDatabaseInternal
import AlertToast
import FirebaseMessaging

enum CreationStage {
    case details, location
}

struct Create: View {
    @State var title = ""
    @State var description = ""
    @State var streetAddress = ""
    @State var expiryDate = Date.now
    @State var images = [UIImage]()
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State var sendingPost = false
    @State var creationStage = CreationStage.details
    @State var invalidLocation = false //shown when post location is invalid
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var account: Account
    @EnvironmentObject var address: Address
    @EnvironmentObject var locationManager: LocationManager
    
    
    var body: some View {
               
        if sendingPost {
            VStack (spacing: 20) {
                ProgressView()
                Text("Sending post")
            }
        } else {
            NavigationView {
                VStack(spacing: 0) {
                    Divider()
                    
                    switch creationStage {
                    case .details:
                        PostDetails(title: $title, description: $description, expiryDate: $expiryDate, images: $images)
                    case .location:
                        PickupLocation(streetAddress: $streetAddress, latitude: $latitude, longitude: $longitude)
                    }
                }
                .onAppear {
                    if let location = locationManager.location {
                        latitude = location.coordinate.latitude
                        longitude = location.coordinate.longitude
                        getAddress(for: location) {updatedAddress in
                            streetAddress = updatedAddress.getStreetAddress()
                        }
                    }
                }
                .navigationTitle("New Post")
                .navigationBarTitleDisplayMode(.inline)
                .toast(isPresenting: $invalidLocation) {
                    AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "Invalid pickup location")
                }
                .toolbar {
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        
                        switch creationStage {
                        case .details:
                            Button("Next") {
                                creationStage = .location
                            }
                            .disabled(title.isEmpty || description.isEmpty || images.count < 3)
                            
        
                        case .location:
                            Button("Done") {
                                sendingPost = true
                                getAddress(for: CLLocation(latitude: latitude, longitude: longitude)) {address in
                                    if address.isValid() {
                                        
                                        //Attempt to retrieve the token again just in case
                                        Messaging.messaging().token {token, _ in
                                            if let token = token {
                                                
                                                //save token to database
                                                Database.database().reference().child("users/\(account.uid)/token").setValue(token)
                                                
                                                //Also save token to user defaults
                                                String.saveToDefaults(model: token, key: "token")
                                            }
                                            
                                        }
                                        
                                        
                                        sendPost(address: address)
                                    } else {
                                        sendingPost = false
                                        invalidLocation = true
                                        print("pickup address invalid. not sending post") //TODO: turn this into a toast??
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func sendPost(address: Address) {
        let city = address.city
        let region = address.state
        let country = address.country
        print("Got city: \(city), region: \(region), country: \(country)")
        let group = DispatchGroup()
        
        //Upload the pictures
        var pics = [URL]()
        let postId = UUID()
        let storageRef = Storage.storage().reference().child("post pictures/\(country)/\(region)/\(city)/\(postId)")
        
        for i in 0..<images.count {
            let image = images[i]
            group.enter()
            storageRef.child("\(i)").putData(image.jpegData(compressionQuality: 0.1)!) {metadata, error in
                
                if error != nil {
                    group.leave()
                } else {
                    print("image uploaded")
                }
                
                //get each image pic
                storageRef.child("\(i)").downloadURL { url, error in
                    guard let url = url else {
                        print("Failed to get image url")
                        group.leave()
                        return
                    }
                    pics.append(url)
                    group.leave()
                }
                
            }
        }
        
        //attach a completion listener to the group
        group.notify(queue: .main) {
            //upload the images
            title = title.trimmingCharacters(in: .whitespaces)
            description = description.trimmingCharacters(in: .whitespaces)
            
            print("post will have \(pics.count) associated images")
            let post = Post(id: postId, userPicURL: account.picURL, userHandle: account.handle, uid: account.uid, title: title, description: description, expiryDate: expiryDate, latitude: latitude, longitude: longitude, images: pics)
            let jsonData = toDict(model: post)
            Database.database().reference().child("posts/\(country)/\(region)/\(city)/\(post.id)").setValue(jsonData)
            Database.database().reference().child("user posts/\(account.uid)/\(post.id)").setValue(jsonData)
            print("Post sent successfully")
            
            //dismiss the view
            dismiss()
            creationStage = .details
        }
    }
}

//TODO: error handling when sending posts???


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

enum CreationStage {
    case details, pictures, location
}

struct Create: View {
    @State var title = ""
    @State var description = ""
    @State var expiryDate = Date.now
    @State var images = [UIImage]()
    @State var latitude = 0.0
    @State var longitude = 0.0
    @State var sendingPost = false
    @State var creationStage = CreationStage.details
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
               
        if sendingPost {
            VStack (spacing: 20) {
                ProgressView()
                Text("Sending post")
            }
        } else {
            NavigationView {
                VStack {
                    switch creationStage {
                    case .details:
                        FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                    case .pictures:
                        FoodPictures(images: $images)
                    case .location:
                        PickupLocation(latitude: $latitude, longitude: $longitude)
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
                        
                        switch creationStage {
                        case .details:
                            Button("Next") {
                                creationStage = .pictures
                            }
                            .disabled(title.isEmpty || description.isEmpty)
                            
                        case .pictures:
                            Button("Next") {
                                creationStage = .location
                            }
                            .disabled(images.count < 3)
                            
                        case .location:
                            Button("Done") {
                                sendingPost = true
                                getCityRegionAndCountry(latitude: latitude, longitute: longitude, completion: sendPost)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func sendPost(city: String, region: String, country: String) {
        print("Got city: \(city), region: \(region), country: \(country)")
        
        //Upload the pictures
        var pics = [URL]()
        var postId = UUID()
        let storageRef = Storage.storage().reference().child("post pictures/\(country)/\(region)/\(city)/\(postId)")
        
        for image in images {
            storageRef.putData(image.jpegData(compressionQuality: 0.1)!) {metadata, error in
                print("image uploaded")
                
                //get each image pic
                storageRef.downloadURL { url, error in
                    guard let url = url else {
                        print("Failed to get image url")
                        return
                    }
                    pics.append(url)
                }
                
            }
        }
        
    
        //send the post
       // while (pics.count < images.count) {}
        print("post will have \(pics.count) associated images")
        let post = Post(id: postId, uid: "", title: title, description: description, expiryDate: expiryDate, latitude: latitude, longitude: longitude, images: pics)
        let jsonData = toDict(model: post)
        Database.database().reference().child("posts/\(country)/\(region)/\(city)").setValue(jsonData)
        print("Post sent successfully")
        
        //dismiss the view
        dismiss()
        creationStage = .details
        
    }
}



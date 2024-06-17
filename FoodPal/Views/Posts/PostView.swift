//
//  PostView.swift
//  FoodPal
//  Created by Phila Dlamini on 6/2/24.
//

import SwiftUI
import FirebaseDatabase
import CoreLocation

struct PostView: View {
    var post: Post
    var dense: Bool
    var ref = Database.database().reference()
    @EnvironmentObject var account: Account
    @EnvironmentObject var favorited: FavoritedPosts
    
    //Provides a means to extract the loaded images
    @EnvironmentObject var profile: ProfilePic
    @EnvironmentObject var foodImages: FoodImages
    @State var id = UUID()
    @State var imgId = UUID()
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: post.userPicURL) {phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .onAppear {
                            profile.image = image
                            print("PostView finished downloading profile pic")
                        }
                } else if phase.error != nil {
                    Color.red
                        .onAppear {
                            id = UUID()
                        }//Retry loading the image here (other idea: try async again in the postView if the iamge was never retrieved
                } else {
                    Circle()
                        .fill(.gray)
                }
            }
            .id(id)
            .frame(width: 35)
            .clipShape(Circle())
            .onTapGesture {
                print("vising poster account info")
            }
                
            VStack (alignment: .leading, spacing: 10) {
                
                VStack (alignment: .leading, spacing: 1){
                    HStack {
                        Text("\(post.title)")
                            .bold()
                        Text("\(post.distance) . Exp \(post.expiryDateText)")
                            .font(.caption)
                        Spacer()
                        
                        if dense {
                            Menu {
                                Button("Block", systemImage: "hand.raised", action: {})
                                Button("Report", systemImage: "flag",  action: {})
                                
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                    }
                    
                    Text("\(post.userHandle)")
                        .font(.caption)
                    
                }
                Text ("\(post.description)")
                
                HStack {
                    ForEach(post.images, id: \.self) {url in
                        AsyncImage(url: url) {phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .onAppear {
                                        if foodImages.images == nil {
                                            foodImages.images = [:]
                                        }
                                        foodImages.images![url.absoluteString] = image
                                        print("PostView downloaded associated food pic")

                                    }
                            } else if phase.error != nil {
                                Color.red.onAppear {
                                    imgId = UUID()
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray)
                            }
                        }
                        .id(imgId)
                        .frame(width: 40, height: 40)
                        .cornerRadius(10)
                            
                    }
                }
                
                if dense {
                    HStack (spacing: 10) {
                        Image(systemName: "fork.knife")
                            .foregroundColor(.gray)
                            .onTapGesture (perform: claim)
                        
                        if favorited.posts.contains(where: { key, value in value.id.uuidString == post.id.uuidString}) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.red)
                                .onTapGesture(perform: unfavorite)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.gray)
                                .onTapGesture(perform: favorite)
                        }
                    }
                }
                
        }
        
    }
    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
    
    func claim() {
        let ref = Database.database().reference().child("claimed/\(account.uid)/\(post.id)")
        let jsonData = toDict(model: post)
        ref.setValue(jsonData)
    }
    
    func favorite() {
        
        //add the post to favorited posts
        ref.child("favorited/\(account.uid)/\(post.id)").setValue(toDict(model: post)) {error, _ in
            if error != nil {
                print("Error favoriting post")
            } else {
                print("Favorited post successfully")
            }
        }
    }
    
    func unfavorite() {
        
        //romove post from favorites
        ref.child("favorited/\(account.uid)/\(post.id)").removeValue() {error, _ in
            if error != nil {
                print("Error unfavoriting post")
            } else {
                print("Unfavorited post")
            }
        }
    }
    
    func report() {
        print("Reporting")
    }
}


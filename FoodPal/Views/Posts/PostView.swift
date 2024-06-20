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
    @EnvironmentObject var account: Account
    @EnvironmentObject var favorited: FavoritedPosts
    @EnvironmentObject var locationManager: LocationManager
    @State var showExpiredAlert = false
    
    //Provides a means to extract the loaded images
    @EnvironmentObject var profile: ProfilePic
    @EnvironmentObject var foodImages: FoodImages
    @State var id = UUID()
    @State var imgId = UUID()
    @State var selectedImage: Image = Image(systemName: "")
    @State var showSelectedImage = false
    
    var body: some View {
        VStack (alignment: .leading) {
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
                .contentShape(Circle())
                
                VStack (alignment: .leading, spacing: 10) {
                    
                    VStack (alignment: .leading, spacing: 1) {
                        HStack (alignment: .center) {
                            Text("\(post.title)")
                                .bold()
                            HStack(alignment: .center, spacing: 0) {
                                Text("\(post.getDistance(from: locationManager.location!)) ")
                                    .font(.caption)
                                
                                if post.isExpired {
                                    HStack(alignment: .center, spacing: 3) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("Expired")
                                    }
                                    .padding(3)
                                    .foregroundColor(.black)
                                    .font(.caption2)
                                    .background(.yellow)
                                    .cornerRadius(10)
                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                                    .onTapGesture {
                                        showExpiredAlert = true
                                    }
                                    
                                    
                                } else {
                                    Text(". Exp \(post.expiryDateText)")
                                        .font(.caption)
                                }
                            }
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
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<post.images.count, id: \.self) {index in
                        let url = post.images[index]
                        
                        return AsyncImage(url: url) {phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .onAppear {
                                        if foodImages.images == nil {
                                            foodImages.images = [:]
                                        }
                                        foodImages.images![url.absoluteString] = image
                                        print("PostView downloaded associated food pic")
                                        
                                    }
                                    .onTapGesture {
                                        selectedImage = image
                                        showSelectedImage = true
                                    }
                                    .fullScreenCover(isPresented: $showSelectedImage) {
                                        ViewImage(image: selectedImage)
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
                        .frame(width: 130, height: 200)
                        .cornerRadius(10)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                
            }
            .onAppear {
                print("num images \(post.images)")
            }
            
            if dense {
                HStack (spacing: 10) {
                    
                    Button(action: {claim(account: account, post: post)}) {
                        HStack(spacing: 5) {
                            Image(systemName: "fork.knife")
                            Text("Claim")
                        }
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(25)
                    
                    Spacer()
                    
                    if favorited.posts.contains(where: { key, value in value.id.uuidString == post.id.uuidString}) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                unfavorite(account: account, post: post)
                            }
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                favorite(account: account, post: post)
                            }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 40, bottom: 0, trailing: 0))
            }
            
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .alert("Expiry date", isPresented: $showExpiredAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            Text("Some food items in this post have expired")
        }
    }
}

func report(account: Account, post: Post) {
    print("reporting this post")
}

func claim(account: Account, post: Post) {
    let ref = Database.database().reference().child("claimed/\(account.uid)/\(post.id)")
    let jsonData = toDict(model: post)
    ref.setValue(jsonData)
}

func favorite(account: Account, post: Post) {
            
    //add the post to favorited posts
    Database.database().reference().child("favorited/\(account.uid)/\(post.id)").setValue(toDict(model: post)) {error, _ in
        if error != nil {
            print("Error favoriting post")
        } else {
            print("Favorited post successfully")
        }
    }
}

func unfavorite(account: Account, post: Post) {
    
    //romove post from favorites
    Database.database().reference().child("favorited/\(account.uid)/\(post.id)").removeValue() {error, _ in
        if error != nil {
            print("Error unfavoriting post")
        } else {
            print("Unfavorited post")
        }
    }
}



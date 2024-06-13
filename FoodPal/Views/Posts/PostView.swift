//
//  PostView.swift
//  FoodPal
//  Created by Phila Dlamini on 6/2/24.
//

import SwiftUI
import FirebaseDatabase

struct PostView: View {
    var post: Post
    var dense: Bool
    var ref = Database.database().reference()
    @EnvironmentObject var account: Account
    @EnvironmentObject var favorited: Favorited
    
    var body: some View {
            HStack(alignment: .top) {
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
                        ForEach(post.images, id: \.self) {image in
                            
                            AsyncImage(url: image) {phase in
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
                            .frame(width: 40, height: 40)
                            .cornerRadius(10)
                                
                        }
                    }
                    
                    if dense {
                        HStack (spacing: 10) {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    print("claiming..")
                                }
                            
                            if favorited.favorited.contains(post.id.uuidString) {
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
        print("Claiming")
    }
    
    func favorite() {
        var favs = favorited.favorited
        favs.append(post.id.uuidString)
        
        ref.child("favorited/\(account.uid)").setValue(favs) {error, _ in
            if let error = error {
                print("Error favoriting post")
            } else {
                print("Favorited post successfully")
            }
        }
    }
    
    func unfavorite() {
        var favs = favorited.favorited
        favs.removeAll(where: {$0 == post.id.uuidString})
        
        ref.child("favorited/\(account.uid)").setValue(favs) {error, _ in
            if let error = error {
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


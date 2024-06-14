//
//  AccountInfo.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct AccountInfo: View {
    @EnvironmentObject var account: Account
    @State var posts: [Post] = []
    
    var body: some View { //TODO: make the posts part of the same scroll view as the rest of the info 
        
        NavigationView {
            ScrollView( .vertical, showsIndicators: false) {
                VStack (spacing: 25) {
                    VStack (spacing: 30) {
                        HStack (alignment: .top) {
                            VStack (alignment: .leading, spacing: 10) {
                                
                                VStack (alignment: .leading) {
                                    Text("\(account.fullName) ")
                                        .font(.title)
                                    Text("\(account.handle)")
                                        .font(.caption)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(account.bio)")
                                    HStack {
                                        Image(systemName: "carrot.fill")
                                        Text("\(account.timesDonated) donations")
                                            .font(.caption)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: account.picURL) {phase in
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
                            .frame(width: 50)
                            .clipShape(Circle())
                        }
                        HStack {
                           
                            Button("Edit profile") {
                                
                            }
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius:5)
                                    .stroke(.white, lineWidth: 1)
                                // .frame(width: 70, height: 40)
                                
                            )
                            
                            //TODO: redesign this to be better please :/
                            Spacer()
                        
                            Button("Sign out", action: signOut)
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius:5)
                                    .stroke(.white, lineWidth: 1)
                                // .frame(width: 70, height: 40)
                                
                            )
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                    
                    ForEach(posts) {post in
                        ZStack {
                            PostView(post: post, dense: false)
                            NavigationLink(destination: PostInfo(post: post)) {}.opacity(0.0)
                        }
                        .listRowBackground(Color.black)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }
            .onAppear(perform: getPosts)
            .padding()
        }
    }
    
    func getPosts() {
        let ref = Database.database().reference().child("user posts/\(account.uid)")
        ref.observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let snapData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: snapData)
                        posts.removeAll(where: {$0.id == post.id})
                        posts.append(post)
                    } catch {
                        print("Failed to decode post from postData in account info")
                    }
                    
                }
            }
        }
        
        ref.observe(.childRemoved) {snapshot in
            for _ in snapshot.children {
                if let snapData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: snapData)
                        posts.removeAll(where: {$0.id == post.id})
                    } catch {
                        print("Failed to decode post from postData in account info")
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            print("about to sign out")
            try Auth.auth().signOut()
            print("should have signed out")
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}


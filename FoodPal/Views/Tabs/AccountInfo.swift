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
    @EnvironmentObject var accountPic: AccountPic
    @EnvironmentObject var account: Account
    @State var showActionSheet = false
    @State var posts: [Post] = []
    @State var imageId = UUID()
    
    var body: some View { //TODO: make the posts part of the same scroll view as the rest of the info
        NavigationView {
            ScrollView( .vertical, showsIndicators: false) {
                VStack (spacing: 25) {
                   /* VStack (spacing: 30) {
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
                            
                            VStack(alignment: .center, spacing: 10) {
                                Image(systemName: "text.justify.trailing")
                                    .onTapGesture {
                                        showActionSheet = true
                                    }
                                
                                if let image = accountPic.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                        .clipShape(Circle())
                                } else {
                                    
                                    AsyncImage(url: account.picURL) {phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .onAppear {
                                                    accountPic.image = image
                                                }
                                        } else if phase.error != nil {
                                            Color.red
                                                .onAppear {
                                                    imageId = UUID()
                                                }
                                        } else {
                                            Circle()
                                                .fill(.gray)
                                        }
                                    }
                                    .id(imageId)
                                    .frame(width: 50)
                                    .clipShape(Circle())
                                }
                    }
                        }
                        HStack {
                            
                            Button("Edit profile") {
                                print("Editting profile not yet supported")
                            }
                            .font(.caption)
                            .foregroundColor(.white)
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
                    } */
                    
                    HStack {
                        if let image = accountPic.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    //show share sheet
                                }
                        } else {
                            
                            AsyncImage(url: account.picURL) {phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .onAppear {
                                            accountPic.image = image
                                        }
                                } else if phase.error != nil {
                                    Color.red
                                        .onAppear {
                                            imageId = UUID()
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.gray)
                                }
                            }
                            .id(imageId)
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                //show share sheet
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("\(account.fullName)")
                                .font(.headline)
                            Text("\(account.handle)")
                                .font(.caption)
                            Text("\(account.bio)")
                        }
                        
                        Spacer()
                         
                        Image(systemName: "nosign")
                    
                    }
                    
                    if posts.isEmpty {
                       
                        Text("No posts")
                            .padding(EdgeInsets(top: 150, leading: 0, bottom: 0, trailing: 0))
                            
                    } else {
                        ForEach(posts) {post in
                            PostListItem(post: post)
                        }
                    }
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
            .confirmationDialog("Logout of FoodPal", isPresented: $showActionSheet) {
                Button("Logout", role: .destructive, action: signOut)
            }
            .padding()
        }
        
    }
    
    func getPosts() {
        print("in get account info")
        
        //Get user posts
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


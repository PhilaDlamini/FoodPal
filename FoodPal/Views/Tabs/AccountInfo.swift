//
//  AccountInfo.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

//Shows blocked users
struct BlockedAccountsView: View {
    @Binding var showBlockedAccounts: Bool
    @EnvironmentObject var account: Account
    @State var blockedAccounts = [Account]()
    @State var showUnblockConfirmation = false
    
    var body: some View {
        VStack {
            
            if blockedAccounts.isEmpty {
                Text("No blocked accounts")
            } else {
                List {
                    ForEach(0..<blockedAccounts.count, id: \.self) {index in
                        let account = blockedAccounts[index]
                        HStack {
                            AsyncImage(url: account.picURL) {phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 30)
                                } else {
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 30)
                                }
                            }
                            
                            VStack {
                                Text("\(account.fullName)")
                                    .bold()
                                Text("\(account.handle)")
                                    .font(.caption)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showUnblockConfirmation = true
                        }
                        .alert("Unblock \(account.fullName)?", isPresented: $showUnblockConfirmation) {
                            Button("Yes", role: .destructive) {
                                blockedAccounts.remove(at: index)
                            }
                            Button("No", role: .cancel) {}
                            
                        } message: {
                            Text("Are you sure you want to unblock \(account.fullName)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Blocked Accounts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem (placement: .topBarLeading) {
                Button(action: {
                    showBlockedAccounts = false
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onAppear(perform: loadBlockedAccounts)
        .onDisappear(perform: updateBlockedAccounts)
    }
    
    //updates blocked accounts
    func updateBlockedAccounts() {
        let newBlockedUIDs = blockedAccounts.map { $0.uid }
        Database.database().reference().child("blocked/\(account.uid)").setValue(newBlockedUIDs)
    }
    
    func loadBlockedAccounts() {
        
        //get all blocked accounts 
        let ref = Database.database().reference()
        ref.child("blocked/\(account.uid)").getData { error, snapshot in
            if let snapshot = snapshot {
                if let blockedUIDs = snapshot.value as? [String] {
                                        
                    //get their account information
                    for blockedUID in blockedUIDs {
                        ref.child("users/\(blockedUID)").getData{err, snapshot in
                            if let snapshot = snapshot {
                                if let accountData = snapshot.value as? [String: Any] {
                                    let acc: Account = try! Account.fromDict(dictionary: accountData)
                                    blockedAccounts.removeAll(where: {$0.uid == acc.uid})
                                    blockedAccounts.append(acc)
                                }
                            }
                        }
                    }
                } else {
                    print("Failed to decode blocked accounts")
                }
            }
        }
    }
}

struct AccountInfo: View {
    @EnvironmentObject var accountPic: AccountPic
    @EnvironmentObject var account: Account
    @State var showActionSheet = false
    @State var showBlockedAccounts = false
    @State var posts: [Post] = []
    @State var imageId = UUID()
    
    var body: some View { //TODO: make the posts part of the same scroll view as the rest of the info
        NavigationView {
            
            if showBlockedAccounts {
                BlockedAccountsView(showBlockedAccounts: $showBlockedAccounts)
            } else {
                ScrollView( .vertical, showsIndicators: false) {
                    VStack(alignment: .center) {
                        
                        //profile pic
                        if let image = accountPic.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                                .padding(.top)
                        } else {
                            
                            AsyncImage(url: account.picURL) {phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                } else if phase.error != nil {
                                    Color.red
                                        .onAppear {
                                            imageId = UUID()
                                        }
                                } else {
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .padding(.top)
                            .id(imageId)
                        }
                        
                        Text("\(account.handle)")
                            .font(.caption)
                        Text("\(account.bio)")
                        
                        
                        if posts.isEmpty {
                            
                            Text("No posts")
                                .padding(EdgeInsets(top: 150, leading: 0, bottom: 0, trailing: 0))
                            
                        } else {
                            
                            VStack {
                                
                                Divider()
                                    .padding([.top, .bottom], 8)
                                
                                ForEach(posts) {post in
                                    PostListItem(post: post, dense: false)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("\(account.fullName)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.white)
                            .onTapGesture {
                                showActionSheet = true
                            }
                    }
                }
                .confirmationDialog("Logout of FoodPal", isPresented: $showActionSheet) {
                    Button("Logout", role: .destructive, action: signOut)
                    Button("Blocked accounts", role: .none) {
                        showBlockedAccounts = true
                    }

                }
                .onAppear {
                    getPosts()
                }
                .padding([.leading, .trailing, .bottom])
            }
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


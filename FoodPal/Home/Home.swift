//
//  ContentView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

enum AuthPage {
    case signIn, createAccount
}

struct Home: View {
    
    //Data for Home view
    @State var currTab = 1
    @State var creatingPost = false
    @State var isNotSignedIn = Auth.auth().currentUser == nil
    @State var doneUploading = true
    @State var page = AuthPage.signIn
    @State var currentUser = Auth.auth().currentUser
    
    //Data accessible to all child views (TODO: adopt this for posts as well)
    @State var locationManager = LocationManager()
    @StateObject var account = Account(fullName: "", email: "", handle: "", bio: "", timesDonated: -1, picURL: URL(fileURLWithPath: ""), uid: "") //the user account
    @StateObject var address = Address() //current user address
    @StateObject var posts = Posts() //all posts for the current city,region,country
    @StateObject var favorited = Favorited() //all postIds favorited by the user 
    
    //Database related
    let ref = Database.database().reference()

    var body: some View {
        
        if let location = locationManager.location {
            VStack {
                VStack {
                    
                    if doneUploading {
                        ZStack (alignment: .bottom) {
                            TabView(selection: $currTab) {
                                
                                //TODO: make the icons actually black
                                Feed()
                                    .tag(1)
                                    .tabItem {
                                        Image(systemName: "house")
                                        
                                    }
                                
                                Search()
                                    .tag(2)
                                    .tabItem {
                                        Image(systemName: "magnifyingglass")
                                            .renderingMode(.template)
                                        
                                    }
                                
                                
                                Text(" ")
                                
                                Favorites()
                                    .tag(4)
                                    .tabItem {
                                        Image(systemName: "heart")
                                    }
                                
                                AccountInfo()
                                    .tag(5)
                                    .tabItem {
                                        Image(systemName: "person.crop.circle")
                                    }
                            }
                            .sheet(isPresented: $creatingPost) {
                                Create()
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    creatingPost = true
                                }) {
                                    Image(systemName: "plus.app") //TODO: put background just like threads
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(15)
                                }
                                Spacer()
                                
                            }
                        }
                    } else {
                        VStack (alignment: .center, spacing: 20) {
                            ProgressView()
                            Text("Finishing account set up")
                        }
                    }
                }
                .sheet(isPresented: $isNotSignedIn) {
                    switch page {
                    case .signIn:
                        SignIn(page: $page, done: $doneUploading)
                    case .createAccount:
                        CreateAccount(page: $page, done: $doneUploading)
                    }
                }
            }
            .onAppear {
                
                //get the address
                getAddress(for: location) {add in
                    address.update(to: add)
                    print("address in home \(address.getString())")
                    attachObservers()
                }
               
                
                //listen to auth events
                Auth.auth().addStateDidChangeListener {auth, user in
                    isNotSignedIn = user == nil
                }
                
                //get the account info of current user
                if let acc = Account.loadFromDefaults() {
                    account.update(to: acc)
                    print("Account data was loaded from user defaults")
                }
            }
            .environmentObject(posts)
            .environmentObject(account)
            .environmentObject(address)
            .environmentObject(favorited)
            .environmentObject(locationManager)
        } else {
            Text("Location not accessible")
        }
    }
    
    //Attach all observers
    func attachObservers() {
        print("Addres string in home: \(address.getString())")

        //Observers for posts at current location
        ref.child("posts/\(address.country)/\(address.region)/\(address.city)").observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: postData)
                        posts.add(post: post)
                    } catch {
                        print("Failed to decode post from postData")
                    }
                }
            }
        }
        
        ref.child("posts/\(address.country)/\(address.region)/\(address.city)").observe(.childRemoved) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: postData)
                        posts.remove(post: post)
                    } catch {
                        print("Failed to decode post from postData")
                    }
                }
            }
            
        }
        
        //Observer for favorited posts
        ref.child("favorited/\(account.uid)").observe(.childAdded) {snapshot in
            if let postId = snapshot.value as? String {
                favorited.add(fav: postId)
            } else {
                print("Failed to get postID as a string")
            }
        }
        
        ref.child("favorited/\(account.uid)").observe(.childRemoved) {snapshot in
            if let postId = snapshot.value as? String {
                favorited.remove(fav: postId)
            } else {
                print("Failed to get postID as a string")
            }
        }
        
        
    }
    
}

#Preview {
    Home()
}

//
//  ContentView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import AlertToast

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
    @State var claimedPost: Post? = nil
    
    //Data accessible to all child views (TODO: adopt this for posts as well)
    @StateObject var postUnavailable = PostUnavailable()
    @StateObject var locationManager = LocationManager()
    @StateObject var account = Account(fullName: "", email: "", handle: "", bio: "", timesDonated: -1, picURL: URL(fileURLWithPath: ""), uid: "") //the user account
    @StateObject var address = Address() //current user address
    @StateObject var posts = Posts() //all posts for the current city,region,country
    @StateObject var favorited = FavoritedPosts() //all posts favorited by the user 
    @StateObject var accountPic = AccountPic() //ther user's profile pic
    @StateObject var blocked = Blocked()

    
    //Database related
    let ref = Database.database().reference()

    var body: some View {
        
        if let location = locationManager.location {
            VStack {
                
                if let claimedPost = claimedPost {
                    Claimed(post: claimedPost)
                } else {
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
                                    
                                    Image(systemName: "plus") //TODO: put background just like threads
                                        .font(.title)
                                        .padding(10)
                                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                                        .foregroundColor(.gray)
                                        .cornerRadius(15)
                                        .padding(5)
                                        .onTapGesture {
                                            creatingPost = true
                                        }
                                    
                                    Spacer()
                                    
                                }
                            }
                            .ignoresSafeArea(.keyboard, edges: .bottom)

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
                    .presentationDetents([.fraction(1.0)])
                }
            }
            .toast(isPresenting: $postUnavailable.unavailable) {
                AlertToast(displayMode: .hud, type: .error(.red), title: "Error", subTitle: "Post unavailable")
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
            .environmentObject(account)
            .environmentObject(address)
            .environmentObject(posts)
            .environmentObject(favorited)
            .environmentObject(locationManager)
            .environmentObject(accountPic)
            .environmentObject(postUnavailable)
            .environmentObject(blocked)
            
        } else {
            Text("Location not accessible")
        }
    }
    
    //Attach all observers
    func attachObservers() {
        print("Addres string in home: \(address.getString())")

        //Observers for posts at current location
        ref.child("posts/\(address.country)/\(address.state)/\(address.city)").observe(.childAdded) {snapshot in
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
        
        ref.child("posts/\(address.country)/\(address.state)/\(address.city)").observe(.childRemoved) {snapshot in
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
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: postData)
                        favorited.add(post: post)
                    } catch {
                        print("Failed to decode post from postData")
                    }
                }
            }

        }
        
        ref.child("favorited/\(account.uid)").observe(.childRemoved) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: postData)
                        favorited.remove(post: post)
                    } catch {
                        print("Failed to decode post from postData")
                    }
                }
            }
        }
        
        //Observer for claimed posts
        ref.child("claimed/\(account.uid)").observe(.childAdded) {snapshot in
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    do {
                        let post: Post = try Post.fromDict(dictionary: postData)
                        claimedPost = post
                    } catch {
                        print("Failed to decode post from postData")
                    }
                }
            }
        }
        
        ref.child("claimed/\(account.uid)").observe(.childRemoved) {snapshot in
            claimedPost = nil
        }
        
        //Observe blocked posts
        ref.child("blocked/\(account.uid)").observe(.value) {snapshot in
            if let blockedList = snapshot.value as? [String] {
                blocked.blocked.formUnion(blockedList)
                print("Blocked data successfully recevied")
            } else {
                print("got weird blocked data \(snapshot.value)")
            }
        }

    }
    
}

#Preview {
    Home()
}

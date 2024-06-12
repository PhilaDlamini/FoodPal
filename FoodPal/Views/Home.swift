//
//  ContentView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import Capture
import FirebaseAuth
import FirebaseDatabaseInternal

enum AuthPage {
    case signIn, createAccount
}

struct Home: View {
    @State var currTab = 1
    @State var creatingPost = false
    @State var isNotSignedIn = Auth.auth().currentUser == nil
    @State var doneUploading = true
    @State var page = AuthPage.signIn
    @StateObject var account = Account(fullName: "", email: "", handle: "", bio: "", timesDonated: -1, picURL: URL(fileURLWithPath: ""), uid: "")
    @State var currentUser = Auth.auth().currentUser
    
    var body: some View {
        
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
    }
    
}

#Preview {
    Home()
}

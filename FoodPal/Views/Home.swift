//
//  ContentView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import Capture
import FirebaseAuth

enum AuthPage {
    case signIn, createAccount
}

struct Home: View {
    @State var currTab = 1
    @State var creatingPost = false
    @State var isNotSignedIn = Auth.auth().currentUser == nil
    @State var doneUploading = true
    @State var page = AuthPage.signIn
    var account = Account( fullName: "Phila Nkosi", email: "", handle: "@phila", bio: "Saving a life one meal at a time", timesDonated: 2, picURL: URL(fileURLWithPath: ""))
    @State var currentUser = Auth.auth().currentUser
    
    var body: some View {
        
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
                        
                        AccountInfo(account: account)
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
        .onAppear {
            
            //listen to auth events
            Auth.auth().addStateDidChangeListener {auth, user in
                isNotSignedIn = user == nil
            }
        }
        .sheet(isPresented: $isNotSignedIn) {
            switch page {
            case .signIn:
                SignIn(page: $page, doneUploading: $doneUploading)
            case .createAccount:
                CreateAccount(page: $page, doneUploading: $doneUploading)
            }
        }
    }
}

#Preview {
    Home()
}

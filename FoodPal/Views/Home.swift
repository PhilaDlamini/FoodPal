//
//  ContentView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/28/24.
//

import SwiftUI
import Capture

struct Home: View {
    @State var currTab = 1
    @State var creatingPost = false
    var account = Account(id: "@phila", firstName: "Phila", lastName: "Nkosi", bio: "Saving a life one meal at a time", timesDonated: 2)
    
    var body: some View {

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
        }
}

#Preview {
    Home()
}

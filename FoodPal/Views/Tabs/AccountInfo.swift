//
//  AccountInfo.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI

struct AccountInfo: View {
    var account: Account
    var posts = [ Post(title: "Chips", userHandle: "@jack", distance: "1.5 mile", description: "We bought these a day ago, nobody wants to have them in the house. Please take them", pictures: ["A", "B", "C", "D", "E"], expiryDate: "7/20"),
                  Post(title: "Veggies", userHandle: "@thenji", distance: "1.8 mile", description: "Fresh vegetables from the store!", pictures: ["A", "B", "D"], expiryDate: "5/11")]
    
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
                            
                            Circle()
                                .fill(.gray)
                                .frame(width: 50)
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
                            
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }
                    }
                    
                    ForEach(posts, id: \.self) {post in
                        ZStack {
                            PostView(post: post, dense: false)
                            NavigationLink(destination: PostInfo(post: post)) {}.opacity(0.0)
                        }
                        .listRowBackground(Color.black)
                        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }
                }
            }
            .padding()
        }
    }
}

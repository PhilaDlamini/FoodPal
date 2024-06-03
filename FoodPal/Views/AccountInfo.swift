//
//  AccountInfo.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI

struct AccountInfo: View {
    var account: Account
    @State var screen = "Posts"
    var screens = ["Posts", "Claimed"]
    var posts = [ Post(title: "Chips", userHandle: "@jack", distance: "1.5 mile", description: "We bought these a day ago, nobody wants to have them in the house. Please take them", pictures: ["A", "B", "C", "D", "E"], expiryDate: "7/20"),
                  Post(title: "Veggies", userHandle: "@thenji", distance: "1.8 mile", description: "Fresh vegetables from the store!", pictures: ["A", "B", "D"], expiryDate: "5/11")]
    var claimed = [ Post(title: "Veggies", userHandle: "@onetwo", distance: "5.5 mile", description: "The freshest veggies. Bought from the store. You should check them out, they are really nice. Should be easy to make too", pictures: ["A", "D", "E"], expiryDate: "7/20"),
                  Post(title: "Pizza", userHandle: "@mikey", distance: "12.8 mile", description: "I bought this but I don't want it anymore. Please come and grab it", pictures: ["A", "G", "H", "B", "D"], expiryDate: "5/11")]
    
    var body: some View {
        
        NavigationView {
            VStack (alignment: .leading, spacing: 30) {
                HStack (alignment: .top) {
                    VStack (alignment: .leading, spacing: 10) {
                        
                        VStack (alignment: .leading) {
                            Text("\(account.firstName) \(account.lastName)")
                                .font(.title)
                            Text("\(account.id)")
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
                Picker("", selection: $screen) {
                    ForEach(screens, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                if screen == "Posts" {
                    List {
                        ForEach(posts, id: \.self) {post in
                            PostView(post: post, dense: false)
                        }
                    }
                } else {
                    List {
                        ForEach(claimed, id: \.self) {post in
                            PostView(post: post, dense: false)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    AccountInfo(account: Account(id: "@phila", firstName: "Phila", lastName: "Nkosi", bio: "Saving a life one meal at a time", timesDonated: 2))
}

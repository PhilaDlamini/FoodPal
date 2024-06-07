//
//  Favorites.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
    
struct Favorites: View {
    let posts = [Post(title: "Salmon", userHandle: "@what", distance: "1 mile", description: "A pack of store-bought, juicy salmon. Unopened. This is the best salmon you've ever seen. You should come see for yourself. You'll be really really pleased. And I think that you would like it very much. Yes", pictures: ["A", "B", "C", "D"], expiryDate: "5/20"),
         Post(title: "Chips", userHandle: "@whatnow", distance: "1.5 mile", description: "We bought these a day ago, nobody wants to have them in the house. Please take them", pictures: ["A", "B", "C", "D", "E"], expiryDate: "7/20"),
         Post(title: "Veggies", userHandle: "@natahan23", distance: "1.8 mile", description: "Fresh vegetables from the store!", pictures: ["A", "B", "D"], expiryDate: "5/11")
    ]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(posts, id: \.self) {post in
                    ZStack {
                        PostView(post: post, dense: true)
                        NavigationLink(destination: PostInfo(post: post)) {}.opacity(0.0)
                    }
                    .listRowBackground(Color.black)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    Favorites()
}

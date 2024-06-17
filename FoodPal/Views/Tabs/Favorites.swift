//
//  Favorites.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
    
struct Favorites: View {
    @State var favoritedPosts: [Post] = []
    @EnvironmentObject var account: Account
    @EnvironmentObject var favorited: FavoritedPosts
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(favorited.posts.values)) {post in
                    PostListItem(post: post)
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

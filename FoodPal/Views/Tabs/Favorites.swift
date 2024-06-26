//
//  Favorites.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import AlertToast
    
struct Favorites: View {
    @State var favoritedPosts: [Post] = []
    @EnvironmentObject var account: Account
    @EnvironmentObject var favorited: FavoritedPosts
    
    var body: some View {
        NavigationView {
            VStack {
                if favorited.posts.isEmpty {
                    Text("No favorites")
                } else {
                    List {
                        ForEach(Array(favorited.posts.values)) {post in
                            PostListItem(post: post)
                        }
                    }
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

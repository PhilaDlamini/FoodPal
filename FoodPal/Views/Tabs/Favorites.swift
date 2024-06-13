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
    @EnvironmentObject var favorited: Favorited
    @EnvironmentObject var posts: Posts
    
    var body: some View {
        NavigationView {
            List {
                ForEach(posts.posts.filter {favorited.favorited.contains($0.id.uuidString)}) {post in
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

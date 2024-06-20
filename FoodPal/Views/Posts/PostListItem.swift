//
//  PostListItem.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/16/24.
//

import SwiftUI

struct PostListItem: View {
    var post: Post
    @StateObject var profile = ProfilePic()
    @StateObject var foodImages = FoodImages()
   // @EnvironmentObject var favorited: FavoritedPosts
    
    var body: some View { //TODO: move all of these into a separate file
        ZStack {
            PostView(post: post, dense: true)
            NavigationLink(destination: PostInfo(post: post)
                .environmentObject(foodImages)
                .environmentObject(profile)
                //.environmentObject(favorited)
            ) {}.opacity(0.0)
        }
        .environmentObject(profile)
        .environmentObject(foodImages)
        .listRowBackground(Color.black)
        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
}

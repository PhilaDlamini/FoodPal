//
//  Feed.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseDatabase

struct Feed: View {
    @EnvironmentObject var posts: Posts
    @EnvironmentObject var address: Address
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(posts.posts.values)) {post in
                   PostListItem(post: post)
                }
            }
            .toolbar {
                ToolbarItem (placement: .principal) {
                    Image(systemName: "carrot")
                        .font(.title2)
                        .onTapGesture {
                            print(address.getString())
                        }
                }
            }
        }
    }
}

#Preview {
    Feed()
}

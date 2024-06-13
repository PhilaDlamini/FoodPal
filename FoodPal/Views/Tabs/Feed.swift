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
                ForEach(posts.posts) {post in
                    ZStack {
                        PostView(post: post, dense: true)
                        NavigationLink(destination: PostInfo(post: post)) {}.opacity(0.0)
                    }
                    .listRowBackground(Color.black)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
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

//
//  Posts.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation

class Posts: ObservableObject {
    @Published var posts: [Post]
    
    init() {
        self.posts = []
    }
    
    func add(post: Post) {
        if !posts.contains(where: {$0.id == post.id}) {
            posts.insert(post, at: 0)
        }
    }
    
    func remove(post: Post) {
        posts.removeAll(where: {$0.id == post.id})
    }
}
 

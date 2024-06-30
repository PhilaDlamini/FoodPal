//
//  Posts.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/13/24.
//

import Foundation

class Posts: ObservableObject {
    @Published var posts: [String: Post]
    
    init() {
        self.posts = [:]
    }
    
    func add(post: Post) {
        posts[post.id.uuidString] = post
    }
    
    func remove(post: Post) {
        posts.removeValue(forKey: post.id.uuidString)
    }
}
 

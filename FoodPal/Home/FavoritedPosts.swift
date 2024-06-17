//
//  FavoritedPosts.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/16/24.
//
import Foundation

class FavoritedPosts: ObservableObject {
    @Published var posts: [UUID: Post]
    
    init() {
        self.posts = [:]
    }
    
    func add(post: Post) {
        posts[post.id] = post
    }
    
    func remove(post: Post) {
        posts.removeValue(forKey: post.id)
    }
}
 

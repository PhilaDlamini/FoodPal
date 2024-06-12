//
//  Feed.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseDatabase

struct Feed: View {
    @State var posts: [Post] = []
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        
        if let location = locationManager.location {
            NavigationView {
                List {
                    ForEach(posts) {post in
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
                    }
                }
            }
            .background(.white)
            .onAppear {
                getCityRegionAndCountry(latitude: location.coordinate.latitude, longitute: location.coordinate.longitude, completion: attachListeners)
            }
        } else {
            Text("No location data")
        }
    }
    
    //listeners
    func attachListeners(city: String, region: String, country: String) {
        let ref = Database.database().reference().child("posts/\(country)/\(region)/\(city)")
        
        ref.observe(.childAdded) {snapshot in
            
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                     let post: Post = try! Post.fromDict(dictionary: postData)
                    if !posts.contains(where: {$0.id == post.id}) {
                        posts.insert(post, at: 0)
                    }
                }
            }
        }
        
        ref.observe(.childRemoved) {snapshot in
            
            for _ in snapshot.children {
                if let postData = snapshot.value as? [String: Any] {
                    let post: Post = try! Post.fromDict(dictionary: postData)
                    posts.removeAll(where: {$0.id == post.id})
                }
            }
            
        }
        
        print("Should have attached listeners")
    }
}

#Preview {
    Feed()
}

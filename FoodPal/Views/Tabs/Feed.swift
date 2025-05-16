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
    @StateObject var locationManager = LocationManager()
    @State var showToolBar = true
    @State private var lastContentOffset: CGFloat = 0
    @State private var scrollDirection: String = "None"
    
    var body: some View {
        NavigationView {
            VStack {
                if posts.posts.isEmpty {
                    Text("No posts in location")
                } else {
                    List {
                        ForEach(Array(posts.posts.values)) {post in
                            PostListItem(post: post)
                        }
                    }
                }
            }
            .toolbar {
                
                ToolbarItem (placement: .principal) {
                    VStack (spacing: 0) {
                           Image("avocado.png")
                               .resizable()
                               .frame(width: 35, height: 35)

                           if locationManager.usingDefaultLocation {
                               HStack(spacing: 0) {
                               Text("Showing results for New York")
                               Button(action: openAppSettings) {
                                   Text("Change").underline()
                               }
                           }
                           .font(.caption)
                           .foregroundColor(.gray)
                           }
                    }
                }
            }
        }
    }
    
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

}

#Preview {
    Feed()
}

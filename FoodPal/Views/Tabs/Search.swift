//
//  Search.swift
//  FoodPal
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseDatabase

struct Search: View {
    @State var city = ""
    @State var region = ""
    @State var country = ""
    @State var results: [Post] = []
    @State var searched = false
    @EnvironmentObject var address: Address
    
    var body: some View {
        NavigationView {
            VStack {
                
                VStack (alignment: .leading, spacing: 20) {
                    TextField("Country", text: $country)
                        .textFieldStyle(.roundedBorder)
                    TextField("Region", text: $region)
                        .textFieldStyle(.roundedBorder)
                    TextField("City", text: $city)
                        .textFieldStyle(.roundedBorder)

                    Button("Search") {
                        search()
                        searched = true
                    }

                }
                
                if searched && results.isEmpty {
                    
                    Text("No results")
                } else {
                    List {
                        ForEach(results) {post in
                            ZStack {
                                PostView(post: post, dense: true)
                                NavigationLink(destination: PostInfo(post: post)) {}.opacity(0.0)
                            }
                            .listRowBackground(Color.black)
                            .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                country = address.country
                region = address.region
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func search() {
        let ref = Database.database().reference().child("posts/\(country)/\(region)/\(city)")
        ref.getData {error, snapshot in
            if let snapshot = snapshot {
                for _ in snapshot.children {
                    if let snapData = snapshot.value as? [String: [String: Any]] {
                        for key in snapData.keys {
                            do {
                                let post: Post = try Post.fromDict(dictionary: snapData[key]!)
                                results.removeAll(where: { $0.id == post.id })
                                results.append(post)
                            } catch {
                                print("Failed to decode post from postData in search")
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Search()
}

//TODO: A post favorited from the search tab won't appear in appear in favorites currently. Please fix this

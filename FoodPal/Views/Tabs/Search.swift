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
    @State var searched = true
    @EnvironmentObject var address: Address
    
    var body: some View {
        NavigationView {
            VStack (spacing: 20) {
                
                HStack {
                    VStack (alignment: .leading, spacing: 25) {
                        Text("Country: ")
                        Text("Region: ")
                        Text("City: ")
                    }
                    
                    VStack (alignment: .leading, spacing: 10) {
                        TextField("Country", text: $country)
                            .padding(5)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        TextField("Region", text: $region)
                            .padding(5)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                        TextField("City", text: $city)
                            .padding(5)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                
                Button("Search") {
                    
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(20)
                
                Divider()
                
                if searched && results.isEmpty {
                    
                    VStack {
                        Spacer()
                        VStack (alignment: .center, spacing: 10) {
                            Image(systemName: "xmark.bin.fill")
                            Text("No results")
                        }
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(results) {post in
                            PostListItem(post: post)
                        }
                    }
                }
            }
            .onAppear {
                country = address.country
                region = address.region
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.automatic)
            .padding()
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

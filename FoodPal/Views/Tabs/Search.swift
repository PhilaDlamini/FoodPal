//
//  Search.swift
//  FoodPal
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI
import FirebaseDatabase
import MapKit


struct Results: View {
    @Binding var showsResults: Bool
    @State var address: Address
    @State var results: [Post] = []
    @EnvironmentObject var blockedAccounts: BlockedAccounts
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
        
                if results.isEmpty {
                    Text ("No posts")
                } else {
                    List {
                        ForEach(results) {post in
                            PostListItem(post: post)
                        }
                    }
                }
            }
            .navigationTitle("\(flagMap[address.country]!) \(address.city)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Image(systemName: "chevron.backward")
                        .onTapGesture {
                            showsResults = false
                        }
                }
            }
            .onAppear {
                searchPosts(at: address)
            }
            
        }
    }
    
    func searchPosts(at address: Address) {
        let ref = Database.database().reference().child("posts/\(address.country)/\(address.state)/\(address.city)")
        ref.getData {error, snapshot in
            if let snapshot = snapshot {
                for _ in snapshot.children {
                    if let snapData = snapshot.value as? [String: [String: Any]] {
                        for key in snapData.keys {
                            do {
                                let post: Post = try Post.fromDict(dictionary: snapData[key]!)
                                
                                //show in search is user not blocked
                                if !blockedAccounts.blocked.contains(post.uid) {
                                    results.removeAll(where: { $0.id == post.id })
                                    results.append(post)
                                }
                            } catch {
                                print("Failed to decode post from postData in search results")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Search: View {
    @State var city = ""
    @State var region = ""
    @State var country = ""
    @State var results: [Post] = []
    @State var searched = true
    @State var countryIndex = 0
    @State var regionIndex = 0
    @State var cityIndex = 0
    @State var selectedAddress = Address()
    
    
    @State var showResults = false
    @State var searchResults: [Address] = []
    @State var searchText = ""
 
    var body: some View {
        
        if showResults  {
            Results(showsResults: $showResults, address: selectedAddress)
        } else {
            
            NavigationView {
                VStack {
                    List {
                        ForEach(searchResults) {address in
                            VStack(alignment: .leading) {
                                Text("\(flagMap[address.country]!) \(address.city)")
                                        .font(.headline)
                                    Text("\(address.state) \(address.country)")
                                        .font(.caption)
                                }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAddress = address
                                showResults = true
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .searchable(text: $searchText, prompt: "City, State")
                .onSubmit(of: .search) {
                    searchLocations(query: searchText)
                }
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
    
    func searchLocations(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        searchResults = []
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            let results = response?.mapItems ?? []
            
            for result in results {
                let cod = result.placemark.coordinate
                getAddress(for: CLLocation(latitude: cod.latitude, longitude: cod.longitude)) {
                    searchResults.append($0)
                }
            }
        }
    }
   

}

#Preview {
    Search()
}

//TODO: A post favorited from the search tab won't appear in appear in favorites currently. Please fix this

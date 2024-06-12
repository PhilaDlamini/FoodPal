//
//  Search.swift
//  FoodPal
//  Created by Phila Dlamini on 5/29/24.
//

import SwiftUI

struct Search: View {
    @State var searchText = ""
//    let searchResults: [Post] = []
    let searchResults: [Post] = []
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.black)
                    TextField("", text: $searchText, prompt: Text("Search posts").foregroundStyle(.black))
                        .foregroundStyle(.black)
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "mic.fill")
                            .foregroundColor(.black)
                    }
                }
                .padding(10)
                .background(Color(red: 28, green: 27, blue: 27, opacity: 1)) //TODO: seems to not apply
                .cornerRadius(25)
                .padding()
               
                if searchText.isEmpty {
                    VStack (alignment: .center, spacing: 10) {
                        Spacer()
                        Image(systemName: "microbe")
                            .font(.largeTitle)
                            .foregroundStyle(.gray)
                        Text("Search results will appear here")
                        Spacer()
                    }
                } else if searchResults.isEmpty {
                    Spacer()
                    Text("No results")
                    Spacer()
                } else {
                    List {
                        ForEach(searchResults) {post in
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
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    Search()
}

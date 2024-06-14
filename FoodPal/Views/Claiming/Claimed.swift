//
//  Claimed.swift
//  FoodPal
//  Created by Phila Dlamini on 6/14/24.
//

import SwiftUI

struct Claimed: View {
    var post: Post
    @State var cancelClicked = false 
    @State var pickUpAddress = Address()
    
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 15) {
                    Text("\(post.title)")
                        .font(.headline)
                    Text("\(post.description)")
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack { //creates views as needed, not all at once
                            ForEach(post.images, id: \.self) {img in
                                
                                AsyncImage(url: img) {phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } else if phase.error != nil {
                                        Color.red
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(width: 200, height: 400)
                                .cornerRadius(25)
                            }
                        }
                    }
                    
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Pickup location:")
                                .font(.headline)
                                .bold()
                            Text("43 Winthrop St\(pickUpAddress.getString())")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack {
                                Text("Directionss")
                                Image(systemName: "arrow.clockwise.square.fill")
                            }
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(20)
                    }
                    
                    
                    Divider()
                    
                    HStack {
                        Spacer()
                        
                        Button("Confirm pickup") {
                            
                        }
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(25)
                        
                        Spacer()
                        
                    }
                    
                }
                .padding()
            }
            
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("You claimed a post")
                        .font(.headline)
                        .bold()
                }
                ToolbarItem {
                    Button(action: {
                        cancelClicked = true
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .alert("Cancel pickup", isPresented: $cancelClicked) {
                Button("Ok", role: .cancel) {
                    print("Canceling post")
                }
                
                Button("No", role: .destructive) {
                  
                }
            } message: {
                Text("Are you sure you want to cancel this pickup?")
            }
        }
    }
    
    func cancelPickUp() {
        print("Canceling pickup")
    }
}

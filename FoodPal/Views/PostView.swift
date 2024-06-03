//
//  PostView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/2/24.
//

import SwiftUI

struct PostView: View {
    var post: Post
    var dense: Bool
    var dummyAccount = Account(id: "@phila", firstName: "Phila", lastName: "Nkosi", bio: "Saving lives one donation at a time", timesDonated: 2)
    
    var body: some View {
        
        //TODO: remove padding around list view
        NavigationLink(destination: PostInfo(post: post)) {
            
            HStack(alignment: .top) {
                
//                NavigationLink(destination: AccountInfo(account: dummyAccount)) {
                    Circle() //TODO: figure out how to implement this 
                        .fill(.gray)
                        .frame(width: 35)
                    
//                }
                VStack (alignment: .leading, spacing: 10) {
                    
                    VStack (alignment: .leading, spacing: 1){
                        HStack {
                            Text("\(post.title)")
                                .bold()
                            Text("\(post.distance) . Exp \(post.expiryDate)")
                                .font(.caption)
                            Spacer()
                            
                            if dense {
                                Menu {
                                    Button("Block", systemImage: "hand.raised", action: {})
                                    Button("Report", systemImage: "flag",  action: {})
                                    
                                } label: {
                                    Image(systemName: "ellipsis")
                                }
                            }
                            
                        }
                        
                        Text("\(post.userHandle)")
                            .font(.caption)
                        
                    }
                    Text ("\(post.description)")
                    
                    HStack {
                        ForEach(post.pictures, id: \.self) {image in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .stroke(.black, lineWidth: 1)
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    if dense {
                        HStack (spacing: 10) {
                            Button(action: claim) {
                                Image(systemName: "fork.knife")
                            }
                            
                            Button(action: favorite) {
                                Image(systemName: "star")
                            }
                            
                        }
                    }
                }
            }
            
        }
        .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }
    
    func claim() {
        print("Claiming")
    }
    
    func favorite() {
        print("favoriting")
    }
    
    func report() {
        print("Reporting")
    }
}


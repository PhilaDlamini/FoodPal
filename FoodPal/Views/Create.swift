//
//  Create.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/30/24.
//

import SwiftUI
import MapKit

struct Create: View {
    @State var title = ""
    @State var description = ""
    @State var expiryDate = Date.now
    @State private var currView = 1 //The current view to show the user. TODO: change to enum (more elegant)
    @State private var nextText = "Next"
    @State var images = [UIImage]()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
               
        NavigationView {
            VStack {
                switch currView {
                case 1: 
                    FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                    
                case 2:
                    FoodPictures(images: $images)
                
                case 3:
                    PickupLocation()
                    
                default:
                    FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("\(nextText)") {
                        if currView == 1 {
                            currView = 2
                        } else if currView == 2 {
                            nextText = "Done"
                            currView = 3
                        } else {
                            //finish
                            post()
                            dismiss()
                        }
                    }
                  //  .disabled(currView == 2 && images.count < 3)
                }
            }
        }
    }
    
    func post() {
        //Post the post to city's database
    }
}



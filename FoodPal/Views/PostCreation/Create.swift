//
//  Create.swift
//  FoodPal
//
//  Created by Phila Dlamini on 5/30/24.
//

import SwiftUI
import MapKit

enum CreationStage {
    case details, pictures, location
}

struct Create: View {
    @State var title = ""
    @State var description = ""
    @State var expiryDate = Date.now
    @State private var creationStage = CreationStage.details 
    @State var images = [UIImage]()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
               
        NavigationView {
            VStack {
                switch creationStage {
                case .details:
                    FoodDetails(title: $title, description: $description, expiryDate: $expiryDate)
                case .pictures:
                    FoodPictures(images: $images)
                case .location:
                    PickupLocation()
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
                     
                    switch creationStage {
                    case .details:
                        Button("Next") {
                            creationStage = .pictures
                        }
                    case .pictures:
                        Button("Next") {
                            creationStage = .location
                        }
                    case .location:
                        Button("Done") {
                            post()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func post() {
        //Post the post to city's database
    }
}



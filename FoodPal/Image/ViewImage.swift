//
//  ViewImage.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/18/24.
//

import SwiftUI

struct ViewImage: View {
    var image: Image
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                image
                    .resizable()
                    .scaledToFit()
                    .toolbar {
                        ToolbarItem (placement: .topBarLeading) {
                            Image(systemName: "multiply.circle.fill")
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    }
            }
        }
    }
}

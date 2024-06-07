//
//  FoodDetails.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/6/24.
//

import SwiftUI


//The form for basic info
struct FoodDetails: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var expiryDate: Date
    
    var body: some View {
        Form  {
            TextField("Title", text: $title)
            
            Section(header: Text("Description")) {
                TextEditor(text: $description)
            }
            
            Section {
                DatePicker("Expiry date", selection: $expiryDate, displayedComponents: .date)
                Text("The earliest expiry date of an item in your donation")
                    .font(.caption)
            }
            
        }
    }
}

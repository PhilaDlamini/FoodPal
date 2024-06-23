//
//  SwiftUIView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/15/24.
//

import SwiftUI
import CoreLocation

struct Test: View {
    
    @State var countries = [Country]()

    var body: some View {
        
        Text("Hi")
            .onAppear {
                getAddress(for: CLLocation(latitude: 12.521110, longitude: -69.968338)) {add in
                    print("country: \(add.country) region: \(add.region) city: \(add.city)")
                }
            }
    }
   
}

//TODO: write in ios notes -- how to get only the data you want from a json object 

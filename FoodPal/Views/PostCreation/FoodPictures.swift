//
//  FoodPictures.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/6/24.
//

import SwiftUI


struct FoodPictures: View {
    @State var showImagePicker = false
    @Binding var images: [UIImage]
    
    var body: some View {
        
        VStack {
            VStack (alignment: .leading) {
                if images.count > 0 {
                    VStack(alignment: .leading, spacing: 10) {
                        ScrollView(.horizontal) {
                            LazyHStack {
                                ForEach(images, id: \.self) {pic in
                                    Image(uiImage: pic)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                        .frame(width: 200, height: 400)
                                }
                            }
                        }
                        .frame(height: 410)
                        .scrollIndicators(.hidden)
                        
                        Text("At least 3 pictures required")
                            .foregroundStyle(.gray)
                            .font(.caption)
                        
                    }
                } else {
                    HStack {
                        Spacer()
                        VStack (alignment: .center, spacing: 10) {
                            Spacer()
                            Image(systemName: "mug")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            
                            Text("Share food pictures")
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Circle()
                            .fill(.white)
                            .stroke(.black, lineWidth: 10)
                            .stroke(.white, lineWidth: 3)
                            .frame(width: 60)
                        
                    }
                    
                    Spacer()
                }
                
                
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $images, isPickerShowing: $showImagePicker, sourceType: .camera)
            }
            .padding()
        }
    }
}

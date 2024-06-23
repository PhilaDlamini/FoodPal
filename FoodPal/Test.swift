//
//  SwiftUIView.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/15/24.
//

import SwiftUI
import CoreLocation

struct Test: View {
    @State var images = [UIImage]()
    @State var title = ""
    @State var description = ""
    @State var showImagePicker = false
    @State var pickFromLibrary = true
    @State var expiryDate = Date.now 

    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                
                Circle() //user pic
                    .fill(.gray)
                    .frame(width: 35)
                
                VStack (alignment: .leading, spacing: 10) {
                    TextField("Food name", text: $title)
                        .bold()
                    
                    TextField("Desribe food", text: $description, axis: .vertical)
                    
                    
                    
                }
               
                
            }
            
                if !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<images.count, id: \.self) {index in
                                let image = images[index]
                                
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 130, height: 200)
                                        .cornerRadius(10)
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .renderingMode(.template)
                                        .onTapGesture {
                                            print("about to remove image at index")
                                            images.remove(at: index)
                                            print("removed image at index")
                                        }
                                        .padding(8)
                                }
                            }
                        }
                        .padding(.leading, 40)
                        
                    }
                    
                }
                
                
            VStack(alignment: .leading, spacing: 10) {

                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            pickFromLibrary = true
                            showImagePicker = true
                        }
                    
                    Image(systemName: "camera.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            pickFromLibrary = false
                            showImagePicker = true
                        }
                    
                }
                
                Text("At least 3 images required")
                    .font(.caption)
            }
            .padding(.leading, 40)
            
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                DatePicker("Expiry date", selection: $expiryDate, in: Date()..., displayedComponents: .date)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            if pickFromLibrary {
                ImagePicker(images: $images, isPickerShowing: $showImagePicker, sourceType: .photoLibrary)
            } else {
                ImagePicker(images: $images, isPickerShowing: $showImagePicker, sourceType: .camera)
            }
        }
        
        
        
    }
   
}

//TODO: write in ios notes -- how to get only the data you want from a json object 

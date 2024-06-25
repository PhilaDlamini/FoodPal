//
//  FoodDetails.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/6/24.
//

import SwiftUI

struct PostDetails: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var expiryDate: Date
    @Binding var images: [UIImage]
    @State var showCameraPicker = false
    @State var showLibraryPicker = false
    @EnvironmentObject var accountPic: AccountPic
    @EnvironmentObject var account: Account
    @State var id = UUID()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
            
                if let image = accountPic.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 35)
                    
                } else {
                    AsyncImage(url: account.picURL) {phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .onAppear {
                                   // accountPic.image = image
                                    print("downloaded account pic in post details")
                                }
                        } else if phase.error != nil {
                            Color.red
                                .onAppear {
                                    id = UUID()
                                }//Retry loading the image here (other idea: try async again in the postView if the iamge was never retrieved
                        } else {
                            Circle()
                                .fill(.gray)
                        }
                    }
                    .clipShape(Circle())
                    .frame(width: 35)
                    .id(id)
                }
                
                VStack (alignment: .leading, spacing: 5) {
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
            
            
            VStack(alignment: .leading, spacing: 5) {
                
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showLibraryPicker = true
                        }
                    
                    Image(systemName: "camera.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showCameraPicker = true
                        }
                    
                }
                
                Text("At least 3 images required")
                    .font(.caption)
            }
            .padding(.leading, 40)
            
            Spacer()
            
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                DatePicker("Expiry date", selection: $expiryDate, in: Date()..., displayedComponents: .date)
            }
        }
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(images: $images, isPickerShowing: $showCameraPicker, sourceType: .camera)
        }
        .sheet(isPresented: $showLibraryPicker) {
            ImagePicker(images: $images, isPickerShowing: $showLibraryPicker, sourceType: .photoLibrary)
        }
        
    }
   
}


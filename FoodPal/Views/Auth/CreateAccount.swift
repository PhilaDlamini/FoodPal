//
//  CreateAccount.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/7/24.
//

import SwiftUI

struct CreateAccount: View {
    @Binding var page: AuthPage
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var handle = ""
    @State var bio = ""
    @State var handleTaken = false
    @State var hidePassword = true
    @State var showImagePicker = false
    @State var images = [UIImage]()
    
    var body: some View {
        NavigationView {
            VStack (spacing: 15) {
                
                if images.isEmpty  {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showImagePicker = true
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                    
                } else {
                    Image(uiImage: images.first!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .onTapGesture {
                            images.removeAll()
                             showImagePicker = true
                        }
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))

                }
                
                Form {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    HStack {
                        TextField("Password", text: $password)
                        Image(systemName: hidePassword ? "eye" : "eye.slash")
                            .onTapGesture {
                                hidePassword.toggle()
                            }
                    }
                    
                    Section("Handle") {
                        TextField("eg. @paul", text: $handle)
                        if handleTaken {
                            Text("Handle not available")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Section("Bio") {
                        TextField("", text: $bio, axis: .vertical)
                    }
                    
                }
                .frame(height: 370)
                
                
                Button("Create") {
                    
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(15)
                
                HStack {
                    Text("Already have an account?")
                    Text("Sign in")
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            page = .signIn
                        }
                }
                
                Spacer()
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $images, isPickerShowing: $showImagePicker, sourceType: .photoLibrary)
            }
        }
    }
}

//
//  CreateAccount.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/7/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabaseInternal
import FirebaseStorage


//TODO: only dismiss the sheet once the backend is done

struct CreateAccount: View {
    @EnvironmentObject var account: Account
    @Binding var page: AuthPage
    @Binding var done: Bool
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
                
                
                Button("Create", action: createUser)
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
            .onAppear {
                done = false
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(images: $images, isPickerShowing: $showImagePicker, sourceType: .photoLibrary)
            }
            .interactiveDismissDisabled()
        }
    }
    
    func createUser() {
        
        if let profilePic = images.first {
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                if let user = authResult?.user {
                    print("Account created")
                    
                    //Upload the profile picture
                    let storageRef = Storage.storage().reference().child("profile pictures").child(user.uid)
                    storageRef.putData(profilePic.jpegData(compressionQuality: 0.4)!) {metadata, error in
                        print("Pic uploaded")
                        
                        storageRef.downloadURL { url, error in
                            guard let url = url else { 
                                print("Failed to get pic url")
                                return
                            }
                            
                            //Save account info in database and user defaults 
                            let acc = Account(fullName: name, email: email, handle: handle, bio: bio, timesDonated: 0, picURL: url, uid: user.uid)
                            let jsonData = toDict(model: acc)
                            Database.database().reference().child("users").child(user.uid).setValue(jsonData)
                            account.update(to: acc)
                            account.saveToDefaults()
                            print("Account info saved to database")
                            done = true 
                        }
                    }
                    
                }
            }
        } else {
            print("No profile pic selected. Aborting")
        }
    }
}

//TODO: down-sample image (takes way too long to upload otherwise!!)


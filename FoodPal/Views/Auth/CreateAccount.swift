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
import FirebaseMessaging

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
    @State var errorMessage = ""
    @State var showErrorMessage = false
    @State var accountCreationInProgress = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
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
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Form {
                            TextField("Name", text: $name)
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                            
                            HStack {
                                if hidePassword {
                                    SecureField("Password", text: $password)
                                } else {
                                    TextField("Password", text: $password)
                                }
                                Image(systemName: hidePassword ? "eye" : "eye.slash")
                                    .onTapGesture {
                                        hidePassword.toggle()
                                    }
                            }
                            .textInputAutocapitalization(.never)
                            
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
                        .scrollDisabled(true)
                        .frame(height: 370)
                        
                        if showErrorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("\(errorMessage)")
                            }
                            .foregroundColor(.orange)
                            .padding([.leading, .bottom], 24)
                        }
                    }
                    
                    Button("Create", action: createUser)
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(15)
                        .disabled(name.isEmpty || email.isEmpty || password.isEmpty || handle.isEmpty || bio.isEmpty || images.isEmpty || accountCreationInProgress)
                    
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
    
    //creates the user acccount
    func createUser() {
        //so users doesn't double click button 
        accountCreationInProgress = true
        email = email.trimmingCharacters(in: .whitespaces)
        password = email.trimmingCharacters(in: .whitespaces)
        bio = bio.trimmingCharacters(in: .whitespaces)
        name = name.trimmingCharacters(in: .whitespaces)
        handle = handle.trimmingCharacters(in: .whitespaces)
        
        //check the handle
        let ref = Database.database().reference().child("handles/\(handle)")
        ref.getData{ error, snapshot in
            if error != nil {
                errorMessage = "Handle checking failure"
                showErrorMessage = true
                accountCreationInProgress = false
            } else if let snapshot = snapshot {
                if snapshot.value is Bool {
                    errorMessage = "Handle taken"
                    showErrorMessage = true
                    accountCreationInProgress = false
                } else {
                    
                    //create the user
                    Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                        if let user = authResult?.user {
                            
                            //Upload the profile picture
                            let profilePic = images.first!
                            let storageRef = Storage.storage().reference().child("profile pictures").child(user.uid)
                            storageRef.putData(profilePic.jpegData(compressionQuality: 0.4)!) {metadata, error in
                                
                                storageRef.downloadURL { url, error in
                                    guard let url = url else {
                                        return
                                    }
                                    
                                    
                                    //Save account info in database and user defaults
                                    let acc = Account(fullName: name, email: email, handle: handle, bio: bio, timesDonated: 0, picURL: url, uid: user.uid, token: "")
                                    
                                    //attempt to retrieve this device token
                                    Messaging.messaging().token { token, error in
                                     if let token = token {
                                         acc.token = token
                                      }
                                        
                                        let jsonData = toDict(model: acc)
                                        Database.database().reference().child("users").child(user.uid).setValue(jsonData)
                                        account.update(to: acc)
                                        Account.saveToDefaults(model: account, key: "account")
                                    }
                            
                                    
                                    //Mark handle as taken
                                    ref.setValue(true)
                                    done = true
                                }
                            }
                            
                        } else {
                            if let error = error {
                                if let errorCode = AuthErrorCode.Code(rawValue: (error as NSError).code) {
                                    switch errorCode {
                                    case .invalidEmail:
                                        errorMessage = "Invalid email"
                                    case .emailAlreadyInUse:
                                        errorMessage = "Email in use"
                                    case .weakPassword:
                                        errorMessage = "Password too weak"
                                    case .operationNotAllowed:
                                        errorMessage = "Operation not allowed"
                                    case .networkError:
                                        errorMessage = "Network error"
                                    default:
                                        errorMessage = "\(error.localizedDescription)"
                                    }
                                } else {
                                    errorMessage = "\(error.localizedDescription)"
                                }
                                showErrorMessage = true
                                accountCreationInProgress = false
                            }
                        }
                    }
                }
            }
        }
    }
}

/*
 
 Known issue:
 - If user creates account and then immediately proceeds to post a donation, they won't be able to receive
 a notification when it is claimed
 
 */


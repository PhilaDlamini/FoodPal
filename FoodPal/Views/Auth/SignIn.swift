//
//  SignIn.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/7/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import AlertToast

struct SignIn: View {
    @State var email = ""
    @State var password = ""
    @State var errorMessage = ""
    @State var showErrorMessage = false
    @State var signinInProgress = false
    @Binding var page: AuthPage
    @Binding var done: Bool
    @State var hidePassword = true
    @EnvironmentObject var account: Account

    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                VStack (alignment: .center, spacing: 20) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Form {
                            TextField("Email", text: $email)
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
                        }
                        .scrollDisabled(true)
                        .textInputAutocapitalization(.never)
                        .frame(height: 130)
                        
                        if showErrorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("\(errorMessage)")
                            }
                            .foregroundColor(.orange)
                            .padding(.leading, 24)
                        }

                    }
                    
                    
                    Button("Sign in", action: signIn)
                        .foregroundColor(.black)
                        .buttonStyle(.borderedProminent)
                        .disabled(email.isEmpty || password.isEmpty || signinInProgress)
                        .cornerRadius(15)


                    
                    HStack {
                        Text("Don't have an account?")
                        Text("Create one")
                            .foregroundStyle(.blue)
                            .onTapGesture {
                                page = .createAccount
                            }
                    }
                    
                    Spacer()
                }
            }
            .onAppear{
                done = true
            }
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
    
    func signIn() {
        signinInProgress = true
        email = email.trimmingCharacters(in: .whitespaces)
        password = password.trimmingCharacters(in: .whitespaces)
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                print("Sign in successful. Retrieving user info ")
                
                //retrieve user data from database
                let ref = Database.database().reference()
                ref.child("users").child(user.uid).observeSingleEvent(of: .value) {snapshot, _ in
                    if let accountData = snapshot.value as? [String: Any] {
                        let acc: Account = try! Account.fromDict(dictionary: accountData)
                        //update the account
                        account.update(to: acc)
                        Account.saveToDefaults(model: acc, key: "account")
                    }
                }
            } else {
                signinInProgress = false
                if let error = error {
                    if let errorCode = AuthErrorCode.Code(rawValue: (error as NSError).code) {
                       switch errorCode {
                       case .invalidEmail:
                           errorMessage = "Invalid email"
                       case .wrongPassword:
                           errorMessage = "Wrong password"
                       case .userNotFound:
                           errorMessage = "User not found"
                       case .userDisabled:
                           errorMessage = "Account disabled"
                       case .tooManyRequests:
                           errorMessage = "Too many attempts"
                       case .networkError:
                           errorMessage = "Network error"
                       default:
                           errorMessage = "Unknown error"
                           print("some error \(errorCode)")
                       }
                   } else {
                       errorMessage = "\(error.localizedDescription)"
                   }
                    showErrorMessage = true
                }
            }
        }
    }
}

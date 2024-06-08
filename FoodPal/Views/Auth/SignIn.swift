//
//  SignIn.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/7/24.
//

import SwiftUI
import FirebaseAuth

struct SignIn: View {
    @State var email = ""
    @State var password = ""
    @Binding var page: AuthPage
    @Binding var doneUploading: Bool
    @State var hidePassword = true

    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 20) {
                Form {
                    TextField("Email", text: $email)
                    HStack {
                        TextField("Password", text: $password)
                        Image(systemName: hidePassword ? "eye" : "eye.slash")
                            .onTapGesture {
                                hidePassword.toggle()
                            }
                    }
                }
                .frame(height: 130)
                
                
                Button("Sign in", action: signIn)
                .buttonStyle(.borderedProminent)
                .cornerRadius(15)
                
                HStack {
                    Text("Dont' have account yet?")
                    Text("Creat one")
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            page = .createAccount
                        }
                }
                
                Divider()
                
//                SignInWithAppleButton(onRequest: {a in
//                    
//                }, onCompletion: {b in
//                    
//                })
//                .frame(width: 40)
                
                Button("Sign in with Apple") {}
                Button("Sign in with Phone") {}
                
                Spacer()
            }
            .onAppear{
                doneUploading = true
            }
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if authResult?.user != nil {
                print("Sign in successful")
            } else {
                print("Failed to sign in")
            }
        }
    }
}

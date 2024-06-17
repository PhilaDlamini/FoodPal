//
//  SignIn.swift
//  FoodPal
//
//  Created by Phila Dlamini on 6/7/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct SignIn: View {
    @State var email = ""
    @State var password = ""
    @Binding var page: AuthPage
    @Binding var done: Bool
    @State var hidePassword = true
    @EnvironmentObject var account: Account

    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                
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
                        account.saveToDefaults()
                    }
                }
            } else {
                print("Failed to sign in")
            }
        }
    }
}

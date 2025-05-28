//
//  AuthenticationView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 21/05/25.
//

import SwiftUI

struct AuthView: View {
    
    @AppStorage("isLoggedIn") var notLogged: Bool = true
    
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var fullName: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var signUp: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            Text("Welcome")
                .font(.title)
                .bold()
                .foregroundColor(Color.theme.orangeColor)
                .padding(.top, 10)
            
            if signUp {
                TextField("Full Name...", text: $fullName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.top)
                
                TextField("Username...", text: $userName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }

            TextField("Email...", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
            }

            HStack {
                NavigationLink {
                    PasswordResetView()
                } label: {
                    Text("Forgot Your Password?")
                        .foregroundStyle(.orangeColour)
                        .font(.callout)
                }


                Spacer()

                if !signUp {
                    Button(action: {
                        Task {
                            try? await viewModel.googleSignIn()
                        }
                    }) {
                        Image("Google")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 8)
                }

                Button(action: {
                    if signUp {
                        Task {
                            try await viewModel.signUp(email: email, fullname: fullName, username: userName, password: password)
                        }
                    } else {
                        Task {
                            await viewModel.signIn(email: email, password: password)
                        }
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color.theme.secondaryTextColor)
                }
            }
            .padding(.top, 10)

            Spacer()

            // Sign Up Link
            HStack {
                Text(signUp ? "Already have an Account?" : "Don't have an Account")
                    .foregroundColor(Color.theme.secondaryTextColor)
                Button(signUp ? "Sign In" : "Sign Up") {
                    signUp.toggle()
                }
                .foregroundColor(Color.theme.orangeColor)
                .bold()
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    NavigationStack {
        AuthView()
            .withPreviewEnvironmentObjects()
    }
}

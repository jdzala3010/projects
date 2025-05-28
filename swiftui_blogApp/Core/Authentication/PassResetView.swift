//
//  PassResetView.swift
//  Blog
//
//  Created by Jaydeep Zala on 28/05/25.
//

import SwiftUI

struct PasswordResetView: View {
    
    @State private var email: String = ""
    @State private var message: String?
    @State private var isSuccess: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            Text("Reset Your Password")
                .foregroundStyle(Color.theme.accentColour)
                .font(.title2)
                .fontWeight(.bold)
            
            TextField("Enter your email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            if let message = message {
                Text(message)
                    .foregroundColor(isSuccess ? .green : .red)
                    .multilineTextAlignment(.center)
            }

            Button("Send Reset Link") {
                Task {
                    let errorMessage = await authViewModel.resetPassword(email: email)
                    if let errorMessage {
                        self.message = errorMessage
                        self.isSuccess = false
                    } else {
                        self.message = "Password reset link sent. Check your email."
                        self.isSuccess = true
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.theme.orangeColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
        .padding()
//        .background(ignoresSafeAreaEdges: .all)
        .background(Color.theme.backgroundColor)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                BackButtonView()
            }
        }
    }
}


#Preview {
    NavigationStack {
        PasswordResetView()
    }
}

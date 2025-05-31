//
//  AuthService.swift
//  Blogger
//
//  Created by Jaydeep Zala on 21/05/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift


@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var author: Author?
    let shared = AuthService.instance

    init() {
        Task {
            await fetchUser()
        }
    }

    func signIn(email: String, password: String) async {
        await shared.signIn(email: email, password: password)
        await fetchUser()
    }

    func signUp(email: String, fullname: String, username: String, password: String) async throws {
        try await shared.signUp(email: email, fullname: fullname, username: username, password: password)
        await fetchUser()
    }

    func signOut() throws {
        try shared.signOut()
        self.author = nil
    }
    
    private func fetchUser() async {
        let snapshot = await shared.getUserSnapshot()
        do {
            self.author = try snapshot?.data(as: Author.self)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func googleSignIn() async throws {
        try await shared.googleSignIn()
        await fetchUser()
    }
    
    func resetPassword(email: String) async -> String? {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return nil
        } catch {
            return error.localizedDescription
        }
    }
    
}

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


final class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    
    static let instance = AuthService()

    private init() {
        self.userSession =  Auth.auth().currentUser
    }

    func signIn(email: String, password: String) async {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch let error {
            print(error.localizedDescription + "sign in")
        }
    }

    func signUp(email: String, fullname: String, username: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let author = Author(id: result.user.uid, name: fullname, username: username, email: email)
            
            let encodedUser = try Firestore.Encoder().encode(author)
            try await Firestore.firestore().collection("author").document(author.id).setData(encodedUser)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        self.userSession = nil
    }
    
    @MainActor
    func googleSignIn() async throws {
        guard let rootVC = UIApplication.shared.topViewController() else {
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
                fatalError("Missing Google client ID in Firebase config")
            }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        
        let user = result.user
        let idToken = user.idToken?.tokenString
        let accessToken = user.accessToken.tokenString
        
        guard let idToken else {
            print("id token not available")
            return
        }
        
        let cridential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        let authResult = try await Auth.auth().signIn(with: cridential)
        self.userSession = authResult.user
        
        let userRef = Firestore.firestore().collection("author").document(authResult.user.uid)
        let docSnapshot = try await userRef.getDocument()
        
        if !docSnapshot.exists {
            let author = Author(
                            id: authResult.user.uid,
                            name: user.profile?.name ?? "No Name",
                            username: user.profile?.email.components(separatedBy: "@").first ?? "username",
                            email: user.profile?.email ?? "no@email.com"
                        )
            try userRef.setData(from: author)
        }
    }
    
    func getUserSnapshot() async -> DocumentSnapshot? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("author")
                .document(uid)
                .getDocument()
            
            return snapshot
        } catch let error {
            print(error.localizedDescription + " couldn't snapshot")
        }
        return nil
    }
}

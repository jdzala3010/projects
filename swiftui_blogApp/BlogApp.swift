//
//  BlogApp.swift
//  Blog
//
//  Created by Jaydeep Zala on 21/05/25.
//

import SwiftUI
import UIKit
import Firebase

@main
struct BlogApp: App {
    
    let viewModel: AuthViewModel
    let addViewModel: AddBlogViewModel
    
    init() {
        FirebaseApp.configure()
        viewModel = AuthViewModel()
        addViewModel = AddBlogViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Tabs()
            }
            .environmentObject(viewModel)
            .environmentObject(addViewModel)
        }
    }
}

//
//  BlogApp.swift
//  Blog
//
//  Created by Jaydeep Zala on 21/05/25.
//

import SwiftUI
import UIKit
import Firebase
import FirebaseCore

@main
struct BlogApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let viewModel: AuthViewModel
    let addViewModel: AddBlogViewModel
    let postlikeViewModel: PostLikeViewModel
    let commentVM: CommentViewModel
    
    init() {
        FirebaseApp.configure()
        viewModel = AuthViewModel()
        addViewModel = AddBlogViewModel()
        postlikeViewModel = PostLikeViewModel()
        commentVM = CommentViewModel()
    }
    
    var body: some Scene {
        
        WindowGroup {
            NavigationView {
                Tabs()
            }
            .environmentObject(viewModel)
            .environmentObject(addViewModel)
            .environmentObject(postlikeViewModel)
            .environmentObject(commentVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {}

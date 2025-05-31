//
//  View.swift
//  Blog
//
//  Created by Jaydeep Zala on 23/05/25.
//

import SwiftUI

extension View {
    func withPreviewEnvironmentObjects() -> some View {
        self
            .environmentObject(AuthViewModel())
            .environmentObject(AddBlogViewModel())
            .environmentObject(PostLikeViewModel())
            .environmentObject(CommentViewModel())
    }
}

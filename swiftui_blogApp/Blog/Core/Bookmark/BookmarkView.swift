//
//  BookmarkView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct BookmarkView: View {
    
    @EnvironmentObject var viewModel: AddBlogViewModel
    
    @State var posts: [Blog] = []
    
    var body: some View {
        VStack {
            PostScrollView(posts: posts)
        }
        .onAppear {
            Task {
                self.posts = try await viewModel.fetchBookmarkedBlogs(userID: AuthService.instance.userSession!.uid)
            }
        }
    }
}

#Preview {
    NavigationView {
        BookmarkView(posts: Blog.mockPosts)
            .withPreviewEnvironmentObjects()
    }
}

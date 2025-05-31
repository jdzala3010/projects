//
//  PostScrollView.swift
//  Blog
//
//  Created by Jaydeep Zala on 28/05/25.
//

import SwiftUI

struct PostScrollView: View {
    
     let posts:[Blog]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(posts) { post in
                   
                    NavigationLink {
                        PostView(blog: post)
                    } label: {
                        BlogRowView(post: post)
                    }

                    Divider()
                }
            }
            .padding(.horizontal, 5)
            .listStyle(.plain)
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        PostScrollView(posts: Blog.mockPosts)
            .withPreviewEnvironmentObjects()
    }
}

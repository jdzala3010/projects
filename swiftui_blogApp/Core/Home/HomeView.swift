//
//  HomeView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI


struct HomeView: View {

    @State var posts = Blog.mockPosts
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(posts) { post in
                    NavigationLink(destination: PostView(blog: post)) {
                        VStack {
                            UserPostDetailsView(post: post)
                                .padding(.horizontal, 5)
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                            
                            PostContentView(post: post, contentLines: 2)
                                .font(.body)
                                .padding(.horizontal, 5)
                            
                            Divider()
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}



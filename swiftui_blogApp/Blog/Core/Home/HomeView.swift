//
//  HomeView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI


struct HomeView: View {

    @EnvironmentObject var viewModel: AddBlogViewModel
    
    @State var posts: [Blog] = []
    
    var body: some View {
        
        ScrollView {
            LazyVStack {
                ForEach(posts) { post in
                    NavigationLink(destination: PostView(blog: post)) {
                        VStack(alignment: .leading, spacing: 10) {
                            UserPostDetailsView(post: post)
                                .padding(.horizontal, 5)
                            
                            Rectangle()
                                .fill(Color(UIColor.secondarySystemBackground))
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                            
                            HStack {
                                ForEach(post.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .foregroundStyle(Color.theme.orangeColor)
                                }
                            }
                            
                            Text(post.title)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.theme.accentColour)
                                .multilineTextAlignment(.leading)
                        }
                            
                            Divider()
                    }
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: {
            Task {
                self.posts = try await viewModel.fetchPublishedBlogs()
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    NavigationView {
        HomeView(posts: Blog.mockPosts)
            .withPreviewEnvironmentObjects()
    }
}



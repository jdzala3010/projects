//
//  PostView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct PostView: View {
    
    @EnvironmentObject var addVM: AddBlogViewModel
    @Environment(\.dismiss) var dismiss
    
    let blog: Blog
    let shared = AuthService.instance
    
    var body: some View {
        ScrollView {
            
            Rectangle()
                .frame(height: 250)
            
            VStack(alignment: .leading, spacing: 16) {
                UserPostDetailsView(post: blog)
                
                PostContentView(post: blog, contentLines: nil)
            }
            .font(.body)
            .padding(.horizontal, 5)
            
            Spacer()
        }
        .scrollIndicators(.hidden)
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 20) {
                    Image(systemName: "heart")
                    Image(systemName: "ellipsis.bubble")
                    Image(systemName: "bookmark")
                    
                    
                    if shared.userSession!.uid == blog.authorID {
                        Image(systemName: "trash")
                            .onTapGesture {
                                Task {
                                    try await addVM.deleteBlog(blogID: blog.id)
                                }
                                dismiss()
                            }

                    }
                }
                .foregroundStyle(Color.theme.accentColour)
                .font(.title3)
                .fontWeight(.medium)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    
    let blog = Blog.mockPosts.first!
    
    NavigationView {
        PostView(blog: blog)

    }
}

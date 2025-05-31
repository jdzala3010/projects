//
//  PostView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI
import UIKit

struct PostView: View {
    
    @EnvironmentObject var addVM: AddBlogViewModel
    @EnvironmentObject var likeVM: PostLikeViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isShowingShareSheet = false
    
    let blog: Blog
    let shared = AuthService.instance
    
    var body: some View {
        ScrollView {
            
            Rectangle()
                .frame(height: 250)
            
            VStack(alignment: .leading, spacing: 16) {
                UserPostDetailsView(post: blog)
                
                PostContentView(post: blog, contentLines: nil)
                
                Spacer()
            }
            .frame(minHeight: 50)
            .font(.body)
            .padding(.horizontal, 5)
            
            Divider()
            
            CommentView(blogID: blog.id, userID: shared.userSession!.uid, username: shared.userSession?.displayName ?? "Anonymous")
            
            Spacer()
        }
        .sheet(isPresented: $isShowingShareSheet, content: {
            ShareSheet(items: ["Check out this awesome blog: Here's blogID: \(blog.id)"])
        })
        .scrollIndicators(.hidden)
        .onAppear(perform: {
            Task {
                try await likeVM.hasUserLiked(blogID: blog.id, userID: shared.userSession!.uid)
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 20) {
                    
                    Image(systemName: "square.and.arrow.up")
                        .onTapGesture {
                            isShowingShareSheet = true
                        }

                    Image(systemName: likeVM.postLiked ?? false ? "heart.fill" : "heart")
                        .onTapGesture {
                            Task {
                                guard let isLiked = likeVM.postLiked else { return }
                                
                                if isLiked {
                                    try await likeVM.unlikePost(blogID: blog.id, userID: shared.userSession!.uid)
                                } else {
                                    try await likeVM.likePost(blogID: blog.id, userID: shared.userSession!.uid)
                                }
                                
                                likeVM.postLiked = !isLiked
                            }
                        }
                    
                    Image(systemName: "bookmark")
                        .onTapGesture {
                            Task {
                                try await addVM.bookmarkBlog(blog: blog)
                            }
                        }
                    
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
            .withPreviewEnvironmentObjects()
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

//
//  CommentView.swift
//  Blog
//
//  Created by Jaydeep Zala on 29/05/25.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject private var commentVM: CommentViewModel

    let blogID: String
    let userID: String
    let username: String

    var body: some View {
        VStack {

            VStack {
                TextEditor(text: $commentVM.newComment)
                    .overlay {
                        Text(commentVM.newComment.isEmpty ? "Enter comment here..." : "")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(.init(top: 7, leading: 7, bottom: 0, trailing: 0))
                            .foregroundStyle(Color.theme.secondaryTextColor)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.theme.orangeColor, style: .init(lineWidth: 2))
                        )

                Button {
                    Task {
                        await commentVM.postComment(blogID: blogID, userID: userID, username: username)
                    }
                } label: {
                    Text("Post Comment")
                        .foregroundStyle(Color.theme.orangeColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.secondarySystemBackground)))
                }
                .padding(.top)
                .disabled(commentVM.newComment.trimmingCharacters(in: .whitespaces).isEmpty)
                
            }
            .padding()
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(commentVM.comments) { comment in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(comment.username)
                                .foregroundStyle(Color.theme.orangeColor)
                                .font(.subheadline)
                                .bold()

                            Text(comment.content)
                                .foregroundStyle(Color.theme.secondaryTextColor)
                                .font(.body)

                            Text(comment.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(Color.theme.secondaryTextColor)
                        }
                        .padding(.bottom, 8)
                        Divider()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await commentVM.fetchComments(for: blogID)
            }
        }
    }
}


#Preview {
    NavigationView {
        CommentView(blogID: Blog.mockPosts.first!.id, userID: Author.mock.id, username: Author.mock.name)
            .withPreviewEnvironmentObjects()
    }
}

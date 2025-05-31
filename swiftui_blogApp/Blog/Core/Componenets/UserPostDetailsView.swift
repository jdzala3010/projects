//
//  UserPostDetailsView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct UserPostDetailsView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    @State var isUpdating: Bool = true
    
    let post: Blog
    let shared = AuthService.instance
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.theme.accentColour)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(post.authorName)
                    .font(.headline)
                    .foregroundStyle(Color.theme.accentColour)
                
                HStack(spacing: 8) {
                    Text((post.updatedAt ?? post.createdAt)
                        .formatted(date: .numeric, time: Date.FormatStyle.TimeStyle.shortened))
                }
                .font(.caption)
                .foregroundColor(Color.theme.secondaryTextColor)
            }
            
            Spacer()
            
            if post.authorID == shared.userSession!.uid {
                NavigationLink(destination: {
                    AddBlogView()
                }, label: {
                    Text("Update")
                        .foregroundStyle(Color.theme.orangeColor)
                        .padding(10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .font(.callout)
                        .fontWeight(.bold)
                })
            }
        }
    }
}

#Preview {
    
    let post = Blog.mockPosts.first!
    
    NavigationView {
        UserPostDetailsView(post: post)
            .withPreviewEnvironmentObjects()
    }
}

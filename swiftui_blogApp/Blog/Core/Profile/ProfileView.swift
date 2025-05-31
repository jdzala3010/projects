//
//  ProfileView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct ProfileView: View {
    
    let author: Author = Author.mock
    
    @EnvironmentObject var authVM: AuthViewModel
    @ObservedObject var addVM: AddBlogViewModel = AddBlogViewModel()
    
    @State var posts: [Blog] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Spacer()
                
                HStack(spacing: 16) {
                    StatView(number: "\(authVM.author?.blogsCount ?? 250)", label: "Posts")
                    StatView(number: "1.2K", label: "Followers")
                    StatView(number: "500", label: "Following")
                }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(authVM.author?.name ?? "Default")
                    .font(.headline)
                if let bio = authVM.author?.bio {
                    Text(bio)
                        .font(.subheadline)
                }
            }
            .padding(.leading)
            
            Button(action: {}) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            Button(action: {
                try? authVM.signOut()
            }) {
                Text("Sign Out")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            PostScrollView(posts: posts)
                .padding(.top)
                .onAppear {
                    Task {
                        posts = try await addVM.fetchBlogs()
                    }
                }
        }
    }
}

#Preview {
    NavigationView {
        ProfileView()
            .withPreviewEnvironmentObjects()
    }
}

extension ProfileView {
    
    struct StatView: View {
        var number: String
        var label: String
        
        var body: some View {
            VStack {
                Text(number)
                    .font(.headline)
                Text(label)
                    .font(.caption)
            }
        }
    }
    
}

//
//  PostDetailsView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct PostContentView: View {
    
    let post: Blog
    let contentLines: Int?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
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
            
            Text(post.content)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .lineLimit(contentLines)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    
    let post = Blog.mockPosts.first!
    
    PostContentView(post: post, contentLines: nil)
}

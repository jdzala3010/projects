//
//  BlogRowView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct BlogRowView: View {

    let post: Blog
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 15) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.accentColour)
                .frame(width: 130, height: 130)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundStyle(Color.theme.accentColour)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Text(post.content)
                    .lineLimit(2)
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.medium)

 
                .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text(post.createdAt.formatted(date: .abbreviated,
                                                  time: .omitted))
                        .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
    }
}

#Preview {
    let post = Blog.mockPosts.first!
    
    BlogRowView(post: post)
}

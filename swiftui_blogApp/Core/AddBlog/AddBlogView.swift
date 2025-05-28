//
//  AddView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 21/05/25.
//

import SwiftUI

struct AddBlogView: View {
    
    @EnvironmentObject var viewModel: AddBlogViewModel
    @EnvironmentObject var vm: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var blog: Blog? = nil
    @Binding var isUpdate: Bool
    
    @State private var blogTitle: String = ""
    @State private var blogTag: String = ""
    @State private var blogContent: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            headerImage
            
            textFields
            
            textEditor
                
            Spacer()
        }
        .onAppear(perform: {
            guard let blog else { return }
            
            self.blogTitle = blog.title
            self.blogContent = blog.content
        })
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView()
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Text(isUpdate ? "Update" : "Post")
                    .foregroundStyle(Color.theme.orangeColor)
                    .font(.title2)
                    .fontWeight(.bold)
                    .onTapGesture {
                        Task {
                            if isUpdate {
                                try? await viewModel.updatePost(postID: blog!.id, newTitle: blogTitle, newContent: blogContent)
                                dismiss()
                            } else {
                                try? await viewModel.createPost(title: blogTitle, content: blogContent, tags: blogTag)
                                dismiss()
                            }
                        }
                    }
            }
        }
    }
}


#Preview {
    NavigationView {
        AddBlogView(isUpdate: .constant(false))
            .withPreviewEnvironmentObjects()
    }
}

extension AddBlogView {
    
    var headerImage: some View {
        HStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColour.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Text("t")
                        .font(.largeTitle)
                        .foregroundColor(Color.theme.backgroundColor)
                )
            
            Text("Add blog header image.\n(Optional)")
                .foregroundColor(Color.theme.accentColour)
                .font(.subheadline)
        }
    }
    
    var textFields: some View {
        Group {
            TextField(text: $blogTitle) {
                Text("Enter blog title...")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .stroke(Color.theme.orangeColor, style: .init(lineWidth: 2)))
            
            TextField(text: $blogTag) {
                Text("Write tags with '#' prefix...")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .padding(.leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .stroke(Color.theme.orangeColor, style: .init(lineWidth: 2)))
        }
    }
    
    var textEditor: some View  {
        TextEditor(text: $blogContent)
            .overlay {
                Text(blogContent.isEmpty ? "Enter content of the blog..." : "")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.init(top: 7, leading: 7, bottom: 0, trailing: 0))
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .stroke(Color.theme.orangeColor, style: .init(lineWidth: 2))
                )
    }
    
}

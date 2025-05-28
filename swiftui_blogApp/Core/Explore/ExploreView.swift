//
//  ExploreView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct ExploreView: View {
    
    @EnvironmentObject var addVM: AddBlogViewModel

    @State var posts:[Blog] = []
    
    var body: some View {
            
        PostScrollView(posts: posts)
        .onAppear {
            Task {
                self.posts = try await addVM.fetchPublishedBlogs()
            }
        }
    }
}

#Preview {
    NavigationView {
        ExploreView()
    }
}

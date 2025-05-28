//
//  SearchView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

struct SearchView: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            TextField(text: $searchText) {
                Text("Search...")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .stroke(Color.theme.accentColour, style: .init(lineWidth: 2)))
            
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        SearchView()
    }
}

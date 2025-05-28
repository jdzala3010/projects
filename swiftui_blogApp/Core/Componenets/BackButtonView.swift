//
//  BackButtonView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 21/05/25.
//

import SwiftUI

struct BackButtonView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundStyle(Color.theme.accentColour)
            .font(.title3)
            .fontWeight(.medium)
            .onTapGesture {
                dismiss()
            }
    }
}

#Preview {
    BackButtonView()
}

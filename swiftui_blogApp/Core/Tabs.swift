//
//  TabView.swift
//  Blogger
//
//  Created by Jaydeep Zala on 20/05/25.
//

import SwiftUI

enum SelectedTab: String {
    case home = "Feed"
    case explore = "Explore"
    case search = "Search"
    case profile = "Profile"
}

struct Tabs: View {
    
    @State var selectedTab: SelectedTab = .home
    @EnvironmentObject var vm : AuthViewModel
    @EnvironmentObject var addVM : AddBlogViewModel
    
    let shared = AuthService.instance

    var body: some View {
        
        if shared.userSession == nil {
            AuthView()
        } else {
            VStack(spacing: 0) {
                navBar
                    .padding(.horizontal)

                Spacer()
                
                switch selectedTab {
                    case .home:
                        HomeView()
                    case .explore:
                        ExploreView()
                    case .profile:
                        ProfileView()
                    case .search:
                        SearchView()
                }

                Spacer()
                
                tabBar
                    .padding(.horizontal, 30)
            }
        }
    }
}

#Preview {
    NavigationView {
        Tabs()
            .withPreviewEnvironmentObjects()
    }
}

extension Tabs {
    
    var navBar: some View {
        HStack {
            Image(systemName: "bell")
                .foregroundStyle(Color.theme.accentColour)
                .font(.title)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(selectedTab.rawValue)
                .font(.headline)
                .fontWeight(.heavy)
            
            Spacer()
            
            if selectedTab != .profile {
                Circle()
                    .frame(width: 35)
            } else {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(Color.theme.accentColour)
                    .font(.title)
                    .fontWeight(.medium)
            }
            
        }
    }
    
    var tabBar: some View {
        HStack {
            Image(systemName: "house")
                .onTapGesture {
                    selectedTab = .home
                }
            
            Spacer()
            
            Image(systemName: "document")
                .onTapGesture {
                    selectedTab = .explore
                }
            
            Spacer()
            
            
            NavigationLink(destination: AddBlogView(isUpdate: .constant(false))) {
                Image(systemName: "plus.app")
            }
            
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .onTapGesture {
                    selectedTab = .search
                }
            
            Spacer()
            
            Image(systemName: "person")
                .onTapGesture {
                    selectedTab = .profile
                }
        }
        .foregroundStyle(Color.theme.accentColour)
        .font(.title2)
        .fontWeight(.medium)
    }
    
}

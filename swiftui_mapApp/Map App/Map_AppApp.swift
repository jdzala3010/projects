//
//  Map_AppApp.swift
//  Map App
//
//  Created by Jaydeep Zala on 18/04/25.
//

import SwiftUI

@main
struct Map_AppApp: App {
    
    @StateObject var locationViewModel : LocationViewModel = LocationViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationView()
                .environmentObject(locationViewModel)
        }
    }
}

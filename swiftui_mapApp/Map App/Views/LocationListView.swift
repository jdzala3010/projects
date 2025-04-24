//
//  LocationListView.swift
//  Map App
//
//  Created by Jaydeep Zala on 18/04/25.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    @Binding var showList: Bool
    
    
    var body: some View {
        List {
            ForEach(locationViewModel.locations) { location in
                ListRowView(location: location)
                    .onTapGesture {
                        locationViewModel.mapLocation = location
                        showList.toggle()
                    }
            }
        }
        .listStyle(.inset)
        .frame(height: 400)
    }
}

#Preview {
    LocationListView(showList: .constant(false))
        .environmentObject(LocationViewModel())
}

extension LocationListView {
    
    func ListRowView(location: Location) -> some View {
        HStack(spacing: 15) {
            Image(location.imageNames.first!)
                .resizable()
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack (alignment: .leading) {
                Text(location.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(location.cityName)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//
//  LocationCardView.swift
//  Map App
//
//  Created by Jaydeep Zala on 20/04/25.
//

import SwiftUI

struct LocationCardView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    let location: Location
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                imageContent
                textContent
            }
            Spacer()
            buttonStack
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LocationCardView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationViewModel())
}

extension LocationCardView {
    
    private var imageContent: some View {
        ZStack {
            Image(location.imageNames.first!)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(location.cityName)
                .font(.headline)
        }
    }
    
    private var buttonStack: some View {
        VStack() {
            Button {
                locationViewModel.showSheet = true
            } label: {
                Text("Learn More")
                    .frame(width: 125, height: 35)
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                locationViewModel.nextButtonPressed(location: location)
            } label: {
                Text("Next")
                    .frame(width: 125, height: 35)
            }
            .buttonStyle(.bordered)

        }
    }
    
}

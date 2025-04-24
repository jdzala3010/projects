//
//  LocationDetailsView.swift
//  Map App
//
//  Created by Jaydeep Zala on 21/04/25.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    
    @EnvironmentObject var locationViewModel: LocationViewModel
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                TabView {
                    ForEach(location.imageNames, id: \.self) { imageName in
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .clipped()
                    }
                }
                .frame(height: 550)
                .tabViewStyle(.page)
                
                Group {
                    Text(location.name)
                        .font(.title)
                        .fontWeight(.heavy)
                    Text(location.cityName)
                        .fontWeight(.semibold)
                }
                .padding(.leading)
                
                Divider()
                
                Text(location.description)
                    .padding()
                    .fontWeight(.medium)
                
                if let url = URL(string: location.link) {
                    Link(destination: url) {
                        Text("Read more on Wikipedia")
                            .tint(.blue)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                    }
                }
                
                Map(position: .constant(MapCameraPosition.region(.init(
                    center: location.coordinates,
                    latitudinalMeters: 7000,
                    longitudinalMeters: 7000)))) {
                    Marker(coordinate: location.coordinates) {
                        Text(location.name)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .allowsHitTesting(false)
            }
            .overlay(alignment: .topLeading) {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundStyle(Color.black)
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding()
                    .padding(.top, 10)
                    .onTapGesture {
                        locationViewModel.showSheet = false
                    }
            }
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    LocationDetailsView(location: LocationsDataService.locations.first!)
        .environmentObject(LocationViewModel())
}

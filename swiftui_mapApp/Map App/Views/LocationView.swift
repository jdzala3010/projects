//
//  ContentView.swift
//  Map App
//
//  Created by Jaydeep Zala on 18/04/25.
//

import SwiftUI
import MapKit

struct LocationView: View {
    
    @EnvironmentObject var locationViewModel : LocationViewModel
    @State var showList: Bool = false
    let locationManager = CLLocationManager()
    
    @State var lookAroundScene: MKLookAroundScene?
    @State var lookAroundSheet: Bool = false
    @State var route: MKRoute?
    
    var body: some View {
        ZStack {
            Map(position: $locationViewModel.mapCam) {
                ForEach(locationViewModel.locations) { location in
                    Annotation(coordinate: location.coordinates) {
                        Image(systemName: "building.columns.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.white)
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(Color.accentColor, in: .circle)
                            .onTapGesture {
                                Task {
                                    lookAroundScene = await locationViewModel.getLookAroungScene(location: location)
                                    lookAroundSheet = true
                                }
                            }
                            
                
                    } label: {
                        Text(location.name)
                    }
                }
                
                UserAnnotation()
                
                if let route {
                    MapPolyline(route)
                        .stroke(Color.accent, lineWidth: 4)
                }
            }
//            .mapControls({
//                MapUserLocationButton()
//                MapCompass()
//                MapPitchToggle()
//                MapScaleView()
//            })
            .ignoresSafeArea()
            
            VStack() {
                
                header
                    .padding(.horizontal)
                
                Spacer()
                
                
                ForEach(locationViewModel.locations) { location in
                    if location == locationViewModel.mapLocation {
                        footer
                            .shadow(color: .black.opacity(0.4), radius: 20)
                            .padding()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)))
                    }
                }
                
            }
        }
        .lookAroundViewer(isPresented: $lookAroundSheet, scene: $lookAroundScene)
        .onAppear(perform: {
            locationManager.requestWhenInUseAuthorization()
            getDirections(to: locationViewModel.mapLocation.coordinates)
        })
        .sheet(isPresented: $locationViewModel.showSheet) {
            LocationDetailsView(location: locationViewModel.mapLocation)
        }
    }
    
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        
        do {
            let update = try await updates.first{$0.location?.coordinate != nil}
            return update?.location?.coordinate
        } catch {
            print("Unable to get directions")
            return nil
        }
    }
    
    func getDirections(to destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else { return }
            print(userLocation)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: 42.8986, longitude: 12.4769)))
            request.destination = MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: 41.8986, longitude: 12.4769)))
            request.transportType = .automobile
            
            let direction = try? await MKDirections(request: request).calculate()
            route = direction?.routes.first
        }
    }
}

#Preview {
    LocationView()
        .environmentObject(LocationViewModel())
}

extension LocationView {
    private var header: some View {
        VStack(spacing: 0) {
            Text(locationViewModel.mapLocation.name + ", " + locationViewModel.mapLocation.cityName)
                .font(.title2)
                .fontWeight(.black)
                .foregroundStyle(Color.primary)
                .frame(height: 55, alignment: .center)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Image(systemName: showList ? "arrow.up" : "arrow.down")
                        .font(.title2)
                        .padding()
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showList.toggle()
                        print("showList: \(showList) by header text")
                    }
                }
            
            if showList {
                LocationListView(showList: $showList)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var footer: some View {
        LocationCardView(location: locationViewModel.mapLocation)
    }
}

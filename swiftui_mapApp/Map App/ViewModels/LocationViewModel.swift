//
//  LocationViewModel.swift
//  Map App
//
//  Created by Jaydeep Zala on 18/04/25.
//

import Foundation
import SwiftUI
import MapKit

class LocationViewModel: ObservableObject {
    
    @Published var locations: [Location]
    @Published var mapLocation: Location {
        didSet {
            updateRegion(location: mapLocation)
        }
    }
    @Published var mapCam: MapCameraPosition
    @Published var showSheet : Bool = false

    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.mapCam = MapCameraPosition.region(MKCoordinateRegion(center: locations.first!.coordinates, span: mapSpan))
    }
    
    func updateRegion(location: Location) {
        withAnimation {
            mapCam = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinates, span: mapSpan))
        }
    }
    
    func nextButtonPressed(location: Location) {
        withAnimation {
            guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else { return }
            let nextIndex = currentIndex + 1
            guard locations.indices.contains(nextIndex) else {
                let firstLocation = locations.first!
                mapLocation = firstLocation
                return
            }

            let nextLocation = locations[nextIndex]
            mapLocation = nextLocation
        }
    }
    
    func getLookAroungScene(location: Location) async -> MKLookAroundScene? {
        let scene = try? await MKLookAroundSceneRequest(coordinate: location.coordinates).scene
        return scene
    }
    
    func getDirection() {
        
    }
}

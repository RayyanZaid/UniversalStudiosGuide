//
//  ContentView.swift
//  UniversalStudiosGuide
//
//  Created by Rayyan Zaid on 7/24/23.
//


import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        Group {
            if locationManager.userLocation == nil {
                LocationRequestView()
            } else if let location = locationManager.userLocation {
                MapPage(location: location)
            }
        }
    }
}


#Preview {
    ContentView()
}

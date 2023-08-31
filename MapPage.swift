//
//  MapPage.swift
//  UniversalStudiosGuide
//
//  Created by Rayyan Zaid on 7/26/23.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapPage: View {
    
    
    var location : CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    
    let simpsons = CLLocationCoordinate2D(latitude: 34.13974, longitude: -118.35404)
    
    
    var body: some View {
        VStack {
            Map() {
                UserAnnotation(anchor: .center)
        
                
            }.mapControls {
                MapCompass()
                MapUserLocationButton()
                MapPitchButton()
            }
            Text("\(self.location.coordinate.latitude)")
        }
        
    }
}

#Preview {
    MapPage(location: CLLocation(latitude: 0, longitude: 0))
}

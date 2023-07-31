//
//  LocationRequestView.swift
//  UniversalStudiosGuide
//
//  Created by Rayyan Zaid on 7/25/23.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            
            VStack {
                
                Spacer()
                
                Image(systemName: "paperplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                    .padding(.bottom, 32)
                
                Text("Enable location tracking?")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Start sharing location")
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 140)
                
                Spacer()
                
                VStack {
                    Button {
                        print("Request location from user")
                        LocationManager.shared.requestLocation()
                    } label: {
                        Text("Allow location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(Color(.systemBlue))
                            
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, -32)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .padding()
                    
                    
                    Button {
                        print("Dismiss")
                    } label: {
                        Text("Maybe later")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 32)
                }
            }
            .foregroundColor(.white)
        }
    }
}

#Preview {
    LocationRequestView()
}

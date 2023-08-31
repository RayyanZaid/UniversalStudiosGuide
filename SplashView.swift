//
//  SplashView.swift
//  AutoVolley
//
//  Created by Rayyan Zaid on 7/19/23.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                AuthenticationView()
            } else {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                Text("Logo Here")
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

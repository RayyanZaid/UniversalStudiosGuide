//
//  UniversalStudiosGuideApp.swift
//  UniversalStudiosGuide
//
//  Created by Rayyan Zaid on 7/24/23.
//

import SwiftUI
import Firebase
@main
struct UniversalStudiosGuideApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

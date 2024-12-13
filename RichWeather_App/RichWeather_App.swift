//
//  RichWeather_AppApp.swift
//  RichWeather_App
//
//  Created by Eason Lin on 12/12/2024.
//

import SwiftUI

@main
struct RichWeather_App: App {
    @StateObject private var networkManager = NetworkManager()
    @AppStorage("isDarkModeEnabled") private var isDarkModeEnabled = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkManager)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
}

#Preview{
    ContentView()
}

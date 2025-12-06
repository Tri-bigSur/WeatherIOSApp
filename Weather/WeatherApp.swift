//
//  WeatherApp.swift
//  Weather
//
//  Created by warbo on 12/11/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject var weatherManager = WeatherManager()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(weatherManager)
        }
    }
}

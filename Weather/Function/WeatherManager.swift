//
//  WeatherManager.swift
//  Weather
//
//  Created by warbo on 5/12/25.
//

import Foundation
import Combine
class WeatherManager: ObservableObject{
    @Published var weatherFavCities: [WeatherModel] = []
    private let api = WeatherAPIService()
    
    
    func addFavCity(_ newCity: WeatherModel){
        if !weatherFavCities.contains(where: {$0.name == newCity.name}){
            weatherFavCities.append(newCity)
        }
    }
}

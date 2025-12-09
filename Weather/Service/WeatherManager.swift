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
    private let apiService = WeatherAPIService()
    
    func refreshAllWeather(){
        let citiesToUpdate = weatherFavCities.map{$0.name}
        for city in citiesToUpdate{
            fetchAndReplaceLocation(city: city)
        }
    }
    
    func fetchAndReplaceLocation(city: String){
        apiService.fetchWeatherData(for: city){ [weak self] result in
            guard let self = self else {return}
            if case .success(let newLocation) = result{
                DispatchQueue.main.async {
                    if let index = self.weatherFavCities.firstIndex(where: {$0.name == newLocation.name}){
                        self.weatherFavCities[index] = newLocation
                    }
                }
            }else if case .failure(let error) = result{
                print("Error refreshing weather for \(city): \(error)")
            }
            
        }
    }
    
    func fetchLocationForSheet(city: String,completion: @escaping (Result<WeatherModel,WeatherAPIError>) -> Void){
        apiService.fetchWeatherData(for: city, completion: completion )
    }
    
    func addFavCity(_ newCity: WeatherModel){
        if !weatherFavCities.contains(where: {$0.name == newCity.name}){
            weatherFavCities.append(newCity)
        }
    }
}

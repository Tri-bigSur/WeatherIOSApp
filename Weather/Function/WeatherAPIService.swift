//
//  WeatherAPIService.swift
//  Weather
//
//  Created by warbo on 2/12/25.
//

import Foundation
import Combine

class WeatherAPIService: ObservableObject{
    //1. Published Property
    @Published var weatherData: WeatherModel?
   
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=a8ddc0fda89401514ca69a95bab80629&lang=vi"
    
    func fetchWeatherData(for cityName: String){
        
          guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
              print("Eror: Could not encode city name")
              return
          }
        // Buid the final url
        let finalURLString = baseURL + "&q=\(cityName)"
        guard let url = URL(string: finalURLString) else {return}
        // Start the network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error{
                print("Network error: \(error.localizedDescription)")
                return
            }
            // Handel Data parsing
            guard let data = data else {return}
            do{
                // Decode data JSON
                let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
                // UI updates (@Published changed happen on main thread)
                DispatchQueue.main.async {
                    self.weatherData = decodedData
                    print("Successfully loaded weather data of city.")
                    
                }
                
            }catch{
                print("Decoding error: \(error)")
                DispatchQueue.main.sync {
                    self.weatherData = nil
                }
            }
        }.resume() // Start data task
    }

   

    
    
}

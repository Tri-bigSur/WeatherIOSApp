//
//  WeatherAPIService.swift
//  Weather
//
//  Created by warbo on 2/12/25.
//

import Foundation
import Combine

enum WeatherAPIError: Error{
    case netWorkError (Error)
    case decodingError(Error)
    case invalidURL
    case noData
}
class WeatherAPIService: ObservableObject{
    //1. Published Property
    @Published var weatherData: WeatherModel?
   
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=a8ddc0fda89401514ca69a95bab80629&lang=vi"
    
    
    
    func fetchWeatherData(for cityName: String,completion: @escaping (Result<WeatherModel,WeatherAPIError>) -> Void){
        
          guard let encodedCity = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
              print("Eror: Could not encode city name")
              return
          }
        // Buid the final url
        let finalURLString = baseURL + "&q=\(encodedCity)"
        guard let url = URL(string: finalURLString) else {
            completion(.failure(.invalidURL))
            return
        }
        // Start the network request
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error{
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.netWorkError(error)))
                return
            }
            // Handel Data parsing
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do{
                // Decode data JSON
                let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
                // UI updates (@Published changed happen on main thread)
                completion(.success(decodedData))
//                DispatchQueue.main.async {
//                    self.weatherData = decodedData
//                    print("Successfully loaded weather data of city.")
//                    
//                }
                
            }catch{
                print("Decoding error: \(error)")
                completion(.failure(.decodingError(error)))
//                DispatchQueue.main.sync {
//                    self.weatherData = nil
//                }
            }
        }.resume() // Start data task
    }
//    func fetchWeatherByCoordinate(lat: Double, lon: Double) async throws -> WeatherModel{
//        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=a8ddc0fda89401514ca69a95bab80629"
//        guard let url = URL(string: urlString)else{
//            throw URLError(.badURL)
//        }
//        let (data, response) = try await URLSession.shared.data(from: url)
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//        let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
//        return decodedData
//    }
    func fetchWeatherByCoords(lat: Double, lon: Double, completion: @escaping(Result <WeatherModel,WeatherAPIError>) -> Void ){
        let urlString = baseURL + "&lat=\(lat)&lon=\(lon)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle errors
            if let error = error{
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.netWorkError(error)))
                return
            }
            // Handel Data parsing
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            do{
                // Decode data JSON
                let decodedData = try JSONDecoder().decode(WeatherModel.self, from: data)
                // UI updates (@Published changed happen on main thread)
                completion(.success(decodedData))
//                DispatchQueue.main.async {
//                    self.weatherData = decodedData
//                    print("Successfully loaded weather data of city.")
//
//                }
                
            }catch{
                print("Decoding error: \(error)")
                completion(.failure(.decodingError(error)))
//                DispatchQueue.main.sync {
//                    self.weatherData = nil
//                }
            }
        }.resume() //
    }

   

    
    
}

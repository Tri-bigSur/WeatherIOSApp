//
//  WeatherModel .swift
//  Weather
//
//  Created by warbo on 14/11/25.
//

import Foundation
import MapKit

// MARK: - WEATHER REPONSE MODE
struct WeatherModel: Codable,Identifiable {
    
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    var visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    
    
    // MARK: - Mock data
    static let mock: WeatherModel = Bundle.main.decode("testData")
}
// MARK: - EXTENSION WEATHERMODEL
extension WeatherModel {
    var localObservationTime: String {
        let utcTimestamp = TimeInterval(self.dt)
        let timezoneOffsetSeconds = self.timezone
        let utcDate = Date(timeIntervalSince1970: utcTimestamp)
        
        guard let localTimeZone = TimeZone(secondsFromGMT: timezoneOffsetSeconds) else{
            return "N/A"
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = localTimeZone
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: utcDate)
        
    }
    var currentIconCode: String {
        return self.weather.first?.icon ?? "01d"
    }
    var visibilityMeasurement: Measurement<UnitLength> {
            // Create a Measurement instance, labeling the raw value as meters
        return Measurement(value: Double(visibility), unit: UnitLength.meters)
        }

        // ✅ Computed property to get the converted value in miles (Double)
        var visibilityInMiles: Int {
            return Int(visibilityMeasurement.converted(to: .miles).value)
        }
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: coord.lat, longitude: coord.lon)
    }
}

// MARK: - CLOUDS
struct Clouds: Codable {
    let all: Int
}
// MARK: - COORD
struct Coord: Codable {
    let lon,lat: Double
    
}
// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax : Double
    let pressure, humidity: Int
    
    var celcius: Int{
                return  Int(((temp - 273.15) * 10).rounded() / 10)
    }
    var celciusMax: Int{
        return  Int(((tempMax - 273.15) * 10).rounded() / 10)
    }
    var celciusMin: Int{
        return Int(((tempMin - 273.15) * 10).rounded() / 10)
    }
    var celciusFeelsLike: Int{
        return Int(((feelsLike - 273.15) * 10).rounded() / 10)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        
    }
}
// MARK: - Sys
struct Sys: Codable{
//    let type: Int?
    let country: String
    let sunrise, sunset: Int
    
}
// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String
    enum CodingKeys: String, CodingKey{
        case id, main
        case icon
        case weatherDescription = "description"
    }
    
}

struct Wind: Codable{
    var mphSpeed: Int {
        return Int(speed * 2.237)
    }
    var mphGust: Int{
        return Int((gust ?? 0) * 2.237)
    }
    
    let speed: Double
    let deg: Int
    let gust: Double?
    
}



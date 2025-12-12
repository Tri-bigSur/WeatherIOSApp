//
//  LocationHeaderView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct LocationHeaderView: View {
    let locationWeather: WeatherModel
    var body: some View {
        VStack{
            Text(locationWeather.name)
                .font(.largeTitle)
            
            Text("\(locationWeather.main.celcius)º")
                .font(.system(size: 40,weight: .thin))
            
            Text(locationWeather.weather.first?.weatherDescription ?? "Getting data...")
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            HStack{
                Text("H:\(locationWeather.main.celciusMax)°")
                Text("L:\(locationWeather.main.celciusMin)°")
            }
            
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    LocationHeaderView(locationWeather:  WeatherModel.mock)
}

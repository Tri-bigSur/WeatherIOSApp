//
//  HumidityElementView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct HumidityElementView: View {
    let locationWeather: WeatherModel
    var body: some View {
        WeatherInfoCardView{
            HStack{
                Image(systemName: "humidity.fill")
                Text("HUMIDITY")
                    .modifier(LabelCardText())
//                                        .padding(.vertical,5)
                Spacer()
                
            }
            VStack(alignment:.leading){
                Text("\(locationWeather.main.humidity)%")
                    .modifier(TitleText())
                    .padding(.vertical,5)
                    
                Spacer()
                Text("Dew point is 16º at this time.")
                                    
            }
            
        }
    }
}

#Preview {
    HumidityElementView(locationWeather: WeatherModel.mock)
}

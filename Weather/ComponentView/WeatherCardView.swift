//
//  WeatherCardView.swift
//  Weather
//
//  Created by warbo on 13/11/25.
//

import SwiftUI

struct WeatherCardView: View {
    // MARK: - PROPERTY
    @State var weatherData: WeatherModel
    
    
    // MARK: - BODY
    var body: some View {
        
            HStack{
                VStack(alignment:.leading,spacing: 15){
                    Text("\(weatherData.cityName)")
                        .font(.system(size: 25,weight: .semibold))
                        
                    Text("11:55")
                        .fontWeight(.regular)
                    Spacer()
                    
                    Text("\(weatherData.weatherCondition)")
                }
                .padding(.leading,10)
                Spacer()
                VStack(){
                    Text("29°C")
                        .font(.system(size: 35, weight: .regular))
                    
                        Spacer()
                    
                    HStack{
                        Text("H: 32°C")
                        Text("L: 23°C")
                            
                    }
                     .fontWeight(.semibold)
                }
                
            }
            .frame(maxWidth:.infinity)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .foregroundStyle(.white)
            .background(Color.blue)
            .cornerRadius(15)
        
        
    }
}

#Preview {
    WeatherCardView(weatherData: WeatherModel(cityName: "Tân An", weatherCondition: "Clear Sky"))
}

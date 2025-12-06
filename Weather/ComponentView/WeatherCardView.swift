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
        
//        ZStack{
//            Image(weatherData.currentIconCode)
//                .resizable()
//                .scaledToFit()
                
            HStack{
                VStack(alignment:.leading,spacing: 10 ){
                    Text("\(weatherData.name)")
                        .lineLimit(1)
                    //                    Text("Bình Tân")
                        .font(.system(size: 25,weight: .semibold))
                        
                    Text("\(weatherData.localObservationTime)")
                    //                    Text("9:00")
                        .fontWeight(.regular)
                    Spacer()
                    
                    Text("\(weatherData.weather.first?.weatherDescription ?? "Getting data...")")
                        .font(.system(size: 18,weight: .regular))
                    
                }
                .padding(.leading,10)
                Spacer()
                VStack(alignment:.center){
                    Text("\(weatherData.main.celcius)°")
                    
                        .font(.system(size: 45, weight: .regular))
                    
                    Spacer()
                    
                    HStack{
                        Text("\(weatherData.main.celciusMax)°")
                        Text("\(weatherData.main.celciusMin)°")
                        //                        Text("C:36")
                        
                    }
                    .fontWeight(.semibold)
//                    .frame(width: .infinity)
                }
                
            }
            .frame(maxWidth:.infinity)
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .foregroundStyle(.white)
            .background(
                Image(weatherData.currentIconCode)
                    .resizable()
                
            )
            .cornerRadius(15)
//        }
        //Zstack
        
        
    }
}

#Preview {
    WeatherCardView(weatherData: WeatherModel.mock)
}

//
//  HourlyForeCastView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct HourlyForeCastView: View {
    let locationWeather: WeatherModel
    var body: some View {
        WeatherInfoCardView{
            VStack(alignment:.leading,spacing: 10){
                Text("Forecast it's rain at 5:00pm. Wind gust to 16 mph.")
                    .fontWeight(.regular)
                Divider()
                    .overlay(.gray)
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(spacing:30){
                        
                        VStack(alignment:.center,spacing: 16){
                            Text("Now")
                                .fontWeight(.medium)
                            VStack{
                                Image(systemName: "cloud.fill")
                                    .font(.system(size: 20))
                                
                            }
                            .frame(height: 25)
                            
                            
                            
                            Text("29°")
                                .font(.system(size: 20,weight: .semibold))
                            
                        }
                        
                        
                        
                        VStack(alignment:.center,spacing: 16){
                            Text("11 am")
                                .fontWeight(.medium)
                            VStack{
                                Image(systemName: "cloud.rain.fill")
                                    .font(.system(size: 20))
                                
                            }
                            .frame(height: 25)
                            
                            
                            
                            Text("31°")
                                .font(.system(size: 20,weight: .semibold))
                            
                        }
                        
                        
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    HourlyForeCastView(locationWeather: WeatherModel.mock)
}

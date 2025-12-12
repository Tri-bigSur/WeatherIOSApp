//
//  DailyForeCastView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct DailyForeCastView: View {
    var body: some View {
        WeatherInfoCardView{
            VStack{
                HStack{
                    Image(systemName: "calendar")
                    Text("FORECAST IN 10 DAYS")
                        .modifier(LabelCardText())
                    Spacer()
                }
                
                
            }
            

            Divider()
                .overlay(.gray)
            DailyWeatherRow(day: "Wednesday", icon: "cloud.drizzle.fill", weatherTendency: "", lTemp: "23", hTemp: "31")
                
                                Divider()
                                    .overlay(.gray)
                                
            DailyWeatherRow(day: "Today", icon: "cloud.fill", weatherTendency: "65%", lTemp: "22", hTemp: "31")
            
                                Divider()
                                    .overlay(.gray)
            DailyWeatherRow(day: "Thursday", icon: "cloud.fill", lTemp: "20", hTemp: "28")
            
            
            
            
            
        }
    }
}

#Preview {
    DailyForeCastView()
}

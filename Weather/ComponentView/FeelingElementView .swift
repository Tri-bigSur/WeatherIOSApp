//
//  FeelingElementView .swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct FeelingElementView_: View {
    let LocationWeather: WeatherModel
    var body: some View {
        WeatherInfoCardView{
            VStack(alignment:.leading){
                HStack{
                    Image(systemName: "thermometer")
                    Text("FEELING")
                        .modifier(LabelCardText())
                    Spacer()
                }
                
                HStack{
                    VStack(alignment:.leading){
                        Text("\(LocationWeather.main.celciusFeelsLike)")
                            .modifier(TitleText())
                            .padding(.vertical,7)
                        Text("Wind is making you feel cooler.")
                        Spacer()
                    }
                    
                }
            }
        }
    }
}

#Preview {
    FeelingElementView_(LocationWeather: WeatherModel.mock)
}

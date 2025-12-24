//
//  ForesightElementView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct ForesightElementView: View {
    let locationWeather: WeatherModel
    var body: some View {
        WeatherInfoCardView{
            HStack{
               Image(systemName: "eye.fill")
               Text("FORESIGHT")
                    .modifier(LabelCardText())
                Spacer()
                
            }
//            HStack{
                VStack(alignment:.leading){
                    Text("\(locationWeather.visibilityInMiles) miles")
                        .modifier(TitleText())
                        .padding(.vertical,5)
                    Spacer()
                    Text("Foresight is completely clear.")
                }

//            }
        }
    }
}

#Preview {
    ForesightElementView(locationWeather: WeatherModel.mock)
}

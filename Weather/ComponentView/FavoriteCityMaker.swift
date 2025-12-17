//
//  FavoriteCityMaker.swift
//  Weather
//
//  Created by warbo on 16/12/25.
//

import SwiftUI

struct FavoriteCityMaker: View {
    let temp: Int
    let cityName: String
    let themeColor: Color
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.primary)
                Circle()
                    .frame(width: 38,height: 38)
                    .foregroundStyle(themeColor)
                VStack{
                    Text("\(temp)")
                        .font(.system(size: 22,weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            Text(cityName)
                .foregroundStyle(.primary)
                .font(.system(size: 15))
        }
    }
}

#Preview {
    FavoriteCityMaker(temp: 20, cityName: "Thủ Thừa", themeColor: Color.nightDarkColor)
}

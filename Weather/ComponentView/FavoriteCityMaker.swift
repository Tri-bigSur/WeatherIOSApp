//
//  FavoriteCityMaker.swift
//  Weather
//
//  Created by warbo on 16/12/25.
//

import SwiftUI
import CoreLocation
struct FavoriteCityMaker: View {
    let item: AnnotationItem
    let mode: MapDisplayMode
    let themeColor: Color
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.primary)
                Circle()
                    .frame(width: 38,height: 38)
                    .foregroundStyle(mode == .temperature ? themeColor : Color.colorAnnotationWind)
                VStack{
                    Text(mode == .temperature ? "\(item.temp)" : "\(item.windSpeed)")
                        .font(.system(size: 22,weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            Text(item.name)
                .foregroundStyle(.primary)
                .font(.system(size: 15))
        }
    }
}

#Preview {
    FavoriteCityMaker(item:AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Tan An", temp: 20, sunrise: 323, sunset: 323, dt: 323, windSpeed: 6, gust: 2, windDeg: 56) , mode: .windSpeed, themeColor: Color.nightDarkColor)
}

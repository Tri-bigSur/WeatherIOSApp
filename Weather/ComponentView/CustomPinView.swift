//
//  CustomPinView.swift
//  Weather
//
//  Created by warbo on 16/12/25.
//

import SwiftUI
import CoreLocation 
struct CustomPinView: View {
//    let temp: Int
//    let cityName: String
    let mode: MapDisplayMode
    let item: AnnotationItem
    let themeColor: Color
    let weatherIcon: String
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundStyle(.primary)
                Circle()
                    .frame(width: 65,height: 65)
                    .foregroundStyle(mode == .temperature ? themeColor : Color.colorAnnotationWind)
                VStack(spacing: mode == .windSpeed ? -5 : 0){
                    if mode == .windSpeed {
                        Text("\(getWindDirection(degrees: item.windDeg))")
                            .font(.system(size: 12,weight: .semibold))
                            .foregroundStyle(.secondary)
                            

                    }
                    Text(mode == .temperature ? "\(item.temp)º" : "\(item.windSpeed)")
                        .font(.system(size: 24,weight: .semibold))
                        .foregroundStyle(.white)
                    if mode == .temperature {
                        Image(systemName: weatherIcon)
                            .font(.system(size: 25))
                            .foregroundStyle(.yellow)
                    } else {
                        Text("MPH")
                            .font(.system(size: 16,weight: .semibold))
                            .foregroundStyle(.secondary)
                            .foregroundColor(.white)
                            
                    }
                }
            }
            PointerTrinangle()
                .foregroundStyle(.primary)
                .frame(width: 10,height: 10)
                .offset(y: mode == .windSpeed ? 10 : 6)
                .rotationEffect(.degrees(180))
            Circle()
                .frame(width: 10,height: 10)
                .foregroundStyle(.primary)
            Text(item.name)
                .foregroundStyle(.primary)
                .font(.system(size: 15))
            
        }
    }
}

    

struct PointerTrinangle: Shape{
    func path(in rect:CGRect)-> Path{
        var path = Path()
        path.move(to: CGPoint(x:rect.midX,y: rect.minY))
        path.addLine(to: CGPoint(x:rect.minX,y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CustomPinView(mode:.windSpeed, item: AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Tan An", temp: 20, sunrise: 323, sunset: 323, dt: 323, windSpeed: 6, gust: 2, windDeg: 154) , themeColor: Color.blue,weatherIcon: "sun.max.fill")
}

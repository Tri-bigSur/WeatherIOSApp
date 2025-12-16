//
//  CustomPinView.swift
//  Weather
//
//  Created by warbo on 16/12/25.
//

import SwiftUI

struct CustomPinView: View {
    let temp: Int
    let cityName: String
    var body: some View {
        VStack{
            ZStack{
                Circle()
                    .frame(width: 70, height: 70)
                Circle()
                    .frame(width: 65,height: 65)
                    .foregroundStyle(.gray)
                VStack{
                    Text("\(temp)º")
                        .font(.system(size: 25,weight: .semibold))
                        .foregroundStyle(.white)
                    Image(systemName: "cloud.fill")
                        .font(.system(size: 25))
                        .foregroundStyle(.white)
                }
            }
            PointerTrinangle()
                .frame(width: 10,height: 10)
                .offset(y:2)
                .rotationEffect(.degrees(180))
            Circle()
                .frame(width: 10,height: 10)
            Text(cityName)
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
    CustomPinView(temp:20, cityName: "Tân An")
}

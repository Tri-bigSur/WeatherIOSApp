//
//  CompassView.swift
//  Weather
//
//  Created by warbo on 1/12/25.
//

import SwiftUI

struct GaugeTickMark: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var length: CGFloat
    var thickness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width,rect.height) / 2
        let startPoint = CGPoint(
            x: center.x + (radius - length) * CGFloat(cos(startAngle.radians)),
            y: center.y + (radius - length) * sin(startAngle.radians)
        )
        let endPoint = CGPoint(
            x: center.x + radius * CGFloat(cos (endAngle.radians)),
            y: center.y + radius * sin (endAngle.radians)
            
        )
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
            .strokedPath(StrokeStyle(lineWidth: thickness,lineCap: .round))
    }
    
}
struct CompassNeedle: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
    
        
        
}



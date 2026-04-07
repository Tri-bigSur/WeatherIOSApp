//
//  SolarPathView.swift
//  Weather
//
//  Created by warbo on 25/12/25.
//

import SwiftUI






struct SolarPathView: View {
    // 0.0 is sunrise, 1.0 is sunset (approximate for this UI)
    @State private var progress: CGFloat = 0.2
    let weatherLocation: WeatherModel

    var body: some View {
        WeatherInfoCardView{
            VStack(alignment: .leading, spacing: 10) {
                // Header
                Label("MẶT TRỜI MỌC", systemImage: "sunrise.fill")
                    .font(.caption)
                    .foregroundColor(.white)
                
                Text("\(Date(timeIntervalSince1970: TimeInterval(weatherLocation.sys.sunrise)),format: .dateTime.hour().minute())")
                    .font(.system(size: 25, weight: .light))
                    .foregroundColor(.white)

                // The Chart Area
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height
                    let midY = height / 2
                    
                    ZStack {
                        // 1. The Horizon Line
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: midY))
                            path.addLine(to: CGPoint(x: width, y: midY))
                        }
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)

                        // 2. The Solar Curve (Sine-like)
                        SunPath(width: width, height: height)
                            .stroke(
                                LinearGradient(colors: [.white.opacity(0.6), .white.opacity(0.2)],
                                               startPoint: .top, endPoint: .bottom),
                                lineWidth: 3
                            )

                        // 3. The Sun Circle
                        Circle()
//                            .fill(Color.black)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .frame(width: 12, height: 12)
                            // This glow effect matches the image
                            .shadow(color: .white.opacity(0.8), radius: 10, x: 0, y: 0)
                            .position(getSunPosition(progress: progress, width: width, height: height))
                    }
                }
                .frame(height: 80) // Constrain the height of the graph
                
                Text("Mặt trời lặn: \(Date(timeIntervalSince1970: TimeInterval(weatherLocation.sys.sunset)),format: .dateTime.hour().minute())")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
        }
        
        
        
    }

    // Custom Path for the curve
    func SunPath(width: CGFloat, height: CGFloat) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: -20, y: height * 0.8))
        // Control points create the "hump"
        path.addCurve(to: CGPoint(x: width*0.9, y: height * 0.8),
                      control1: CGPoint(x: width * 0.3, y: height + 30),
                      control2: CGPoint(x: width * 0.3, y: -height * 1.5))
        path.addCurve(to: CGPoint(x: width*2, y: height * -0.2),
                      control1: CGPoint(x:  width + 20  , y: height + 30),
                      control2: CGPoint(x: width + 70 , y: height * 0.8))
        return path
    }

    // Calculate position on the curve based on progress (0.0 to 1.0)
    func getSunPosition(progress: CGFloat, width: CGFloat, height: CGFloat) -> CGPoint {
        let x = width * progress + 10
        // A simple parabolic formula to mimic the curve: y = a(x-h)^2 + k
        // Or simply sample the path (more advanced). For simplicity, a sine calculation:
        let y = height * 0.8 - sin(progress * .pi) * (height * 0.8)
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    SolarPathView(weatherLocation: WeatherModel.mock)
}

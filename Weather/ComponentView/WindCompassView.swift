//
//  WindCompassView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct WindCompassView: View {
    var currentHeading: Double = 180
    private let exclusionTolerance: Double = 7.0
    private let labelAngles: [Double] = [0.0,90.0,180.0,270]
    private let needleLength: CGFloat = 60
    private let needleThickness: CGFloat = 6
    let locationWeather: WeatherModel
    var body: some View {
        WeatherInfoCardView{
            HStack{
                Image(systemName: "wind")
                Text("Wind")
                    .modifier(LabelCardText())
                Spacer()
            }
            HStack{
                VStack{
                    HStack{
                        Text("Wind")
                            .modifier(AnnotationText())
                        Spacer()
                        Text("\(locationWeather.wind.mphSpeed) mph")
                            .modifier(LabelCardText())
                    }
                    Divider()
                        .overlay(.gray)
                    HStack{
                        Text("Gust")
                            .modifier(AnnotationText())
                            
                        Spacer()
                        Text("\(locationWeather.wind.mphGust) mph")
                            .modifier(LabelCardText())
                    }
                    Divider()
                        .overlay(.gray)
                    HStack{
                        Text("Dimension")
                            .modifier(AnnotationText())
                        Spacer()
                        Text("\(locationWeather.wind.deg)")
                            .modifier(LabelCardText())
                        Text("\(getWindDirection(degrees: locationWeather.wind.deg))")
                            .modifier(LabelCardText())
                    }
                }
                // MARK: - COMPASS
                //.1 TICK MARK
                VStack{
                    ZStack{
                        Circle()
                            .fill(.clear)
                            
                            
                        ForEach(0..<60){ i in
                            let angleDegrees = Angle.degrees(Double(i) * (360.0/60.0))
                            let isMajorTick = i % 5 == 0
                            
                            let shouldExclude = labelAngles.contains{ labelAngle in
                                let diff = abs(angleDegrees.degrees - labelAngle)
                                let wrappedDiff = min(diff, 360.0 - diff)
                                
                                return wrappedDiff < exclusionTolerance
                                
                            }
                            if !shouldExclude{
                                GaugeTickMark(
                                    startAngle: angleDegrees,
                                    endAngle: angleDegrees,
                                    length: isMajorTick ? 12 : 6,
                                    thickness: isMajorTick ? 2 : 1
                                )
                                .stroke(Color.white.opacity(0.7),lineWidth: isMajorTick ? 2 : 1)
                            }
                           
                        }
                        
                        Group{
                            Text("E")
                                .font(.system(size: 15))
                                .modifier(LabelCardText())
                                .offset(y:-60)
                                .rotationEffect(.degrees(90))
                            Text("S")
                                .font(.system(size: 15))
                                .modifier(LabelCardText())
                                .offset(y:-60)
                                .rotationEffect(.degrees(180))
                            Text("W")
                                .font(.system(size: 15))
                                .modifier(LabelCardText())
                                .offset(y:-60)
                                .rotationEffect(.degrees(270))
                                
                        }
                        Text("N")
                            .font(.system(size: 15))
                            .modifier(LabelCardText())
                            .offset(y:-60)
                        
                        CompassNeedle()
                            .fill(Color.white)
                            .frame(width: needleThickness,height: needleLength*0.7)
                            .offset(y:-45)
                            .rotationEffect(.degrees(Double(180 + locationWeather.wind.deg)))
                        CompassNeedle()
                            .fill(Color.white)
                            .frame(width: needleThickness,height: needleLength*0.7)
                            .offset(y:-45)
                            .rotationEffect(.degrees(Double(locationWeather.wind.deg)))
                        VStack(spacing: 2){
                            Text("\(locationWeather.wind.mphSpeed)")
                                .font(.system(size: 22,weight: .bold))
                            Text("mph")
                                .offset(y: -3)
                                .font(.system(size: 10))
                        }
                        
                    }
                }
                .frame(width: 120,height: 120)
                .padding(5)
                
                
                
            }
            
        }
    }
}

#Preview {
    WindCompassView(locationWeather: WeatherModel.mock)
}

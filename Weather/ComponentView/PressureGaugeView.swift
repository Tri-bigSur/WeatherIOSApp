//
//  PressureGaugeView .swift
//  Weather
//
//  Created by warbo on 24/12/25.
//

import SwiftUI

struct PressureGaugeView: View {
    let locationWeather: WeatherModel
    
    let totalTicks = 50
    var body: some View {
        WeatherInfoCardView{
            HStack{
                Image(systemName:"gauge.with.dots.needle.bottom.50percent")
                Text("PRESSURE")
                Spacer()
            }
            .modifier(LabelCardText())
            .padding(.bottom,10)
            VStack{
                ZStack{
                    ForEach(0..<totalTicks, id:\.self){ i in
                        Rectangle()
                            .fill(tickColor(for: i))
                            .frame(width: 3,height: 15)
                            .offset(y: -70)
                            .rotationEffect(.degrees(Double(i) * (240 / Double(totalTicks))))
                        
                    }
                    .rotationEffect(.degrees(240))
                    Rectangle()
                        .frame(width: 6,height: 20)
                        .offset(y: -70)
                    VStack(spacing: 8){
                        Image(systemName: "arrow.down")
                            .font(.system(size: 25,weight: .bold))
                        Text("\(locationWeather.main.pressure)")
                            .font(.system(size: 28,weight: .semibold))
                        Text("mbar")
                            .font(.system(size: 18))
                        HStack{
                            Text("Low")
                            Spacer()
                            Text("High")
                            
                        }
                        .frame(width: 180)
                        .font(.system(size: 20))
                    }
                    .foregroundStyle(.primary)
                    .offset(y:10)
                    
                }
            }
        }
            
        
        
    }
    func tickColor(for index: Int) -> Color {
            let percentage = Double(index) / Double(totalTicks)
            // Adjust these values to hide ticks at the bottom (approx 4:00 to 8:00 positions)
            if percentage > 0.45 && percentage < 0.55 {
                return Color.white.opacity(0.1)
            }
            return Color.white.opacity(0.6)
        }
}

#Preview {
    PressureGaugeView(locationWeather: WeatherModel.mock)
}

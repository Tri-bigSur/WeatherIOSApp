//
//  DataWeatherRow.swift
//  Weather
//
//  Created by warbo on 25/11/25.
//

import SwiftUI

struct DataWeatherRow: View {
    // MARK: - PROPERTY
    var day: String
    var icon: String
    var weatherTendency: String?
    var lTemp: String
    var hTemp: String
    
    var body: some View {
        GeometryReader{geometry in
            HStack(alignment:.center,spacing:0){
                
                HStack(spacing: 0){
                Text(day)
                    .font(.system(size: 16,weight: .medium))
                    .lineLimit(1)
                    Spacer(minLength: 0)
                    }
                .frame(width: geometry.size.width * 0.35)
                
                            
                
                VStack(alignment:.center,spacing: 2){
                    
                    if let text = weatherTendency, !text.isEmpty {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                        Text(text)
                            .foregroundStyle(.teal)
                            .font(.system(size: 15,weight: .semibold))
                        
                        
                    } else {
                        
                        Image(systemName: icon)
                            .font(.system(size: 20))
                    }
                    
                }
                .frame(width: 34,height: 40)
                
                HStack{
                    Text("\(lTemp)°")
                        .font(.system(size: 20))
                        .foregroundStyle(.secondary)
                    ZStack{
                        Capsule()
                            .frame(width:geometry.size.width * 0.2, height: 5)
                            .foregroundStyle(.ultraThinMaterial)
                        Capsule()
                            .frame(width:geometry.size.width * 0.2 * 0.7, height: 5)
                            .foregroundStyle(.orange)
                            .offset(x: 20)
                    }
//                    .padding(.leading,-5)
                    
                    
                    
                    
                        Text("\(hTemp)°")
                            .font(.system(size: 20))
                    
                            .padding(.leading,5)
                }
                .frame(width: geometry.size.width * 0.5)
                
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
        }
        .frame(height: 50)
        
        
        
        
        
        
        
    }
}

#Preview {
    DataWeatherRow(day: "Wednesday", icon: "cloud.fill", weatherTendency: "65%", lTemp: "22", hTemp: "31")
}

//
//  UVElementView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct UVElementView: View {
    var body: some View {
        WeatherInfoCardView{
            VStack(alignment:.leading){
                HStack{
                    Image(systemName: "sun.max.fill")
                    Text("UV")
                        .modifier(LabelCardText())
                    
                }
                
                VStack(alignment:.leading){
                    Text("5")
                        .modifier(TitleText())
                        .padding(.top,2)
                        
                    Text("Normal")
                        .font(.system(size: 18,weight: .semibold))
                    Capsule()
                        .frame(height: 4)
                        .foregroundStyle(Color.multiColored)
                        
                    Text("Avoiding sun shine until 16:00")
                }
            }
        }
    }
}

#Preview {
    UVElementView()
}

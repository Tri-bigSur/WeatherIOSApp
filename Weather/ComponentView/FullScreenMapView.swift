//
//  FullScreenMapView.swift
//  Weather
//
//  Created by warbo on 13/12/25.
//

import SwiftUI
import MapKit
struct FullScreenMapView: View {
    let locationWeather: WeatherModel
    @State private var dragOffset: CGSize = .zero
    let dismissThreshold: CGFloat = 100
    @Binding var isPresented: Bool
//    @Binding var mapRegion: MKCoordinateRegion
    var body: some View {
        ZStack{
            
            WindMapView(locationWeather: locationWeather, isFullScreen: true)
            HStack{
                
                Button{
                    isPresented = false
                }label: {
                    WeatherInfoCardView{
                        Text("Done")
                            .font(.system(size: 18,weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(5)
                    }
                    
                }
                
                
                Spacer()
                
            }
            .frame(maxHeight:.infinity,alignment: .top)
        }
        .offset(y:dragOffset.height)
        .scaleEffect(scaleForDrag())
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    if gesture.translation.height > 0 {
                        dragOffset = gesture.translation
                        
                    }
                    
                }
                .onEnded{ gesture in
                    if dragOffset.height > dismissThreshold{
                        withAnimation(.spring()){
                            isPresented = false
                        }
                    }else{
                        withAnimation(.spring()){
                            dragOffset = .zero
                        }
                    }
                    
                }
        )
       
        
    }
    private func scaleForDrag()-> CGFloat{
        let maxScaleChange: CGFloat = 0.1
        let dragRatio = dragOffset.height / dismissThreshold
        let scale = 1.0 - (min(dragRatio,1.0) * maxScaleChange)
        return scale
    }
}

#Preview {
    FullScreenMapView(locationWeather: WeatherModel.mock, isPresented: .constant(true))
}

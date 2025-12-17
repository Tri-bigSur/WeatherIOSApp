//
//  SingleLocationContentView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI

struct SingleLocationContentView: View {
    @Environment(\.dismissModal) var dismissModal
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var weatherManager: WeatherManager
    let isPresentedAsSheet: Bool
    @Binding var showingFullMap: Bool
    let locationWeather: WeatherModel
    var isCityAdded: Bool{
        weatherManager.weatherFavCities.contains{ location in
            location.name == locationWeather.name
            
        }
    }
    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            VStack{
                if isPresentedAsSheet{
                    HStack{
                        Button(
                            "Cancel"
                            
                        ){
                            dismiss()
                        }
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .buttonStyle(ScaleButtonStyle())
                        
                        Spacer()
                        
                        if !isCityAdded{
                            Button(action:{
                                weatherManager.addFavCity(locationWeather)
                                dismiss()
                                
                            }){
                                Text("Add")
                                    .font(.system(size: 20,weight: .semibold))
                                    .foregroundStyle(.white)
                                
                            }
                            .buttonStyle(ScaleButtonStyle())
                            
                            
                        }
                        
                    }
                    .padding(20)
                    
                }
                
                // Location Header
                LocationHeaderView(locationWeather: locationWeather)
                //                        .foregroundStyle(.white)
                //                        Spacer()
                HourlyForeCastView(locationWeather: locationWeather)
                DailyForeCastView()
                if !isPresentedAsSheet{
                    WeatherInfoCardView{
                        VStack{
                            HStack{
                                               Image(systemName: "wind")
                                               Text("WIND MAP")
                           
                                                   .modifier(LabelCardText())
                                               Spacer()
                                           }
                            
                                WindMapView(locationWeather: locationWeather, isFullScreen: false)
                                
                        }
                        
                    }
                    .onTapGesture{
                        showingFullMap = true
                    }
                }
                
                HStack{
                    ForesightElementView(locationWeather: locationWeather)
                    HumidityElementView(locationWeather: locationWeather)
                
                }
                
                WindCompassView(locationWeather: locationWeather)
                                
                
               
                // MARK: - Map View
                
                HStack(alignment:.center){
                    FeelingElementView_(LocationWeather: locationWeather)
                    UVElementView()
                        
                        
                        
                        
                        
                    
                }
                // MARK: - WIND SPEED
                
                
               

            } // MARK: - General Vstack
            .frame(maxWidth:.infinity)
            .padding(.bottom,isPresentedAsSheet ? 0 : 100)
            
                        
                        }
//        .padding(.bottom, isPresentedAsSheet ? 0 : 80)
//        .background(.gray)
    }
}

#Preview {
    let mockManager = WeatherManager()
    SingleLocationContentView(isPresentedAsSheet: false, showingFullMap: .constant(false), locationWeather: WeatherModel.mock)
        .environmentObject(mockManager)
}

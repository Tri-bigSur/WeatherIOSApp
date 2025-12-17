//
//  WindMapView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI
import MapKit
import CoreLocation
struct WindMapView: View {
    let locationWeather: WeatherModel
    let isFullScreen: Bool
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var region: MKCoordinateRegion
    @State private var annotationItems: [AnnotationItem] = []
    @State private var selectedAnnotationID: UUID?
    
    init(locationWeather:WeatherModel, isFullScreen: Bool){
        self.locationWeather = locationWeather
        self.isFullScreen = isFullScreen
        let initialRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationWeather.coord.lat, longitude: locationWeather.coord.lon), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        _region = State(initialValue: initialRegion)
        
        let initialAnnotation = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: locationWeather.coord.lat, longitude: locationWeather.coord.lon), name: locationWeather.name,temp:locationWeather.main.celcius,sunrise: locationWeather.sys.sunrise,sunset: locationWeather.sys.sunset,dt: locationWeather.dt)
        _annotationItems = State(initialValue: [initialAnnotation])
        
        
        
    }
    func updateLocation(from favoriteCities: [WeatherModel]){
        let newAnnotation = favoriteCities.map{ city in
            return AnnotationItem(coordinate: city.coordinate, name: city.name,temp:city.main.celcius,sunrise: city.sys.sunrise,sunset: city.sys.sunset,dt: city.dt)
            
        }
        self.annotationItems = newAnnotation
        
        
   }
    
    private func isCurrentLocation(_ item: AnnotationItem) -> Bool{
        let currentCoord = locationWeather.coord
        let itemCoord = item.coordinate
        let tolerance = 0.000001
        return abs(currentCoord.lat - itemCoord.latitude) < tolerance && abs(currentCoord.lon - itemCoord.longitude) < tolerance 
    }
    var body: some View {
                
            Map(
                coordinateRegion: $region ,
                interactionModes: isFullScreen ? .all : [],
                annotationItems: annotationItems,
                annotationContent: { item in
                                        MapAnnotation(
                                            coordinate: item.coordinate,
                                            anchorPoint: (selectedAnnotationID == item.id) ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 0.5, y: 0.5)
                                            
                                        ) {
                                            let currentColor = getThemeColor(for: item)
                                            let weatherIcon = getWeatherIcon(for: item)
                                            VStack{
                                                if selectedAnnotationID == item.id && isFullScreen{
                                                    CustomPinView(temp: item.temp, cityName: item.name,themeColor:currentColor,weatherIcon: weatherIcon)
                                                        .transition(.scale.combined(with: .opacity))
                                                    
                                                }else{
                                                    if region.span.latitudeDelta < 2.0{
                                                        FavoriteCityMaker(temp: item.temp, cityName: item.name,themeColor:currentColor)
                                                            .transition(.opacity.animation(.easeInOut))
                                                    }
                                                }
                                            }
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    selectedAnnotationID = item.id
                                                }
                                                    

                                            }
                                                
                                            
                                        }
                                  
                    
                 
                    
                }
            )

        
            .frame(width: isFullScreen ? .infinity : 280, height: isFullScreen ? .infinity : 280)
//            .frame(minHeight: isFullScreen ? .infinity : 200, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(maxWidth: isFullScreen ? .infinity : 400, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(minHeight:0, maxHeight: 400)
//                .ignoresSafeArea(isFullScreen ? .all : [],edges: .all)
            
            .onAppear{
                updateLocation(from: weatherManager.weatherFavCities)
                if let currentCity = annotationItems.first(where: {isCurrentLocation($0)}){
                    selectedAnnotationID = currentCity.id
                }
                   
                }
                .cornerRadius(10)
                .ignoresSafeArea(.all)
                
                .padding(isFullScreen ? 0 : 6)
//            }
//        }
    }
}
extension WindMapView{
    private func getThemeColor(for item: AnnotationItem) -> Color {
        if item.dt >= item.sunrise && item.dt <= item.sunset {
            return Color.morningBlueColor
        }else {
            return Color.nightDarkColor
        }
       
    }
    private func getWeatherIcon(for item: AnnotationItem) -> String {
        if item.dt >= item.sunrise && item.dt <= item.sunset {
            return "sun.max.fill"
        }else{
            return "moon.stars.fill"
        }
    }
}
extension Color{
    static  let morningBlueColor = Color("ColorAnnotationDay")
    static  let nightDarkColor = Color("ColorAnnotationNight")
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
    let name: String
    let temp: Int
    let sunrise: Int
    let sunset: Int
    let dt: Int
}

#Preview {
    WindMapView(locationWeather: WeatherModel.mock, isFullScreen: true)
        .environmentObject(WeatherManager())
}

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
    //    = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var annotationItems: [AnnotationItem] = []
    //    [
    //        AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000))]
    init(locationWeather:WeatherModel, isFullScreen: Bool){
        self.locationWeather = locationWeather
        self.isFullScreen = isFullScreen
        let initialRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationWeather.coord.lat, longitude: locationWeather.coord.lon), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        _region = State(initialValue: initialRegion)
        let initialAnnotation = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: locationWeather.coord.lat, longitude: locationWeather.coord.lon), name: locationWeather.name,temp:locationWeather.main.celcius)
        _annotationItems = State(initialValue: [initialAnnotation])
        
        
    }
    func updateLocation(from favoriteCities: [WeatherModel]){
        let newAnnotation = favoriteCities.map{ city in
            return AnnotationItem(coordinate: city.coordinate, name: city.name,temp:city.main.celcius)
            
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
                annotationItems: annotationItems,
                annotationContent: { item in
                                        MapAnnotation(
                                            coordinate: item.coordinate,
                                            anchorPoint: isCurrentLocation(item) ? CGPoint(x: 0.5, y: 1.0) : CGPoint(x: 0.5, y: 0.5)
                                            
                                        ) {
                                            if isCurrentLocation(item){
                                                CustomPinView(temp: item.temp, cityName: item.name)
                                            }else{
                                                FavoriteCityMaker(temp: item.temp, cityName: item.name)
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
                
                   
                }
                .cornerRadius(10)
                .ignoresSafeArea(.all)
                
                .padding(isFullScreen ? 0 : 6)
//            }
//        }
    }
}


#Preview {
    WindMapView(locationWeather: WeatherModel.mock, isFullScreen: true)
        .environmentObject(WeatherManager())
}

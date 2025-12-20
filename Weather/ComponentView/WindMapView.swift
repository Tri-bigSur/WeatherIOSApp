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
    private let apiService = WeatherAPIService()
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var region: MKCoordinateRegion
    @State private var annotationItems: [AnnotationItem] = []
    @State private var selectedAnnotationID: UUID?
    @State private var showingAnnotationSheet: Bool = false
    @StateObject var locationManager = LocationManager()
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
                
        ZStack{
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
            if isFullScreen {
                HStack{
            
                    Spacer()
                    WeatherInfoCardView{
                    VStack{
                            Button(action:{
                                locationManager.requestLocation()
                            }){
                                Image(systemName: "location.fill")
                                    .font(.system(size: 18,weight: .semibold))
                                    .foregroundStyle(.white)
                                    
                            }
                         // List Annotation Item
                        Divider()
                            .frame(width: 15,height: 10)
                        Button(action:{
                            showingAnnotationSheet = true
                        }){
                            Image(systemName: "list.bullet")
                                .font(.system(size: 20,weight: .semibold))
                                .foregroundStyle(.white)
                        }
                            
                           
                        }
                    .padding(10)
                    }
                    .padding(.top,40)
                    
                }
                .frame(maxHeight:.infinity,alignment: .top)
                .sheet(isPresented: $showingAnnotationSheet){
                    AnnotationListView(annotationItems: annotationItems,selectedID: $selectedAnnotationID)
                        .presentationDetents([.medium,.large])
                }
            }
                
            
        }
        
        
//        .frame(width: isFullScreen ? .infinity : 280, height: isFullScreen ? .infinity : 280)
        .frame(width: isFullScreen ? nil : 280, height: isFullScreen ? nil : 280)
//            .frame(minHeight: isFullScreen ? .infinity : 200, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(maxWidth: isFullScreen ? .infinity : 400, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(minHeight:0, maxHeight: 400)
//                .ignoresSafeArea(isFullScreen ? .all : [],edges: .all)
            .onChange(of: locationManager.lastLocation){ newCoords in
                if let coords = newCoords {
                    updateMapForCurrentLocation(coords)
                    
                }
                
            }
            .onChange(of: selectedAnnotationID){ newID in
                if let selectedPin = annotationItems.first(where:{$0.id == newID}){
                    withAnimation(.easeInOut){
                        region.center = selectedPin.coordinate
                        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    }
                }
                
            }
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
    private func updateMapForCurrentLocation(_ coords: CLLocationCoordinate2D){
        withAnimation(.easeInOut){
            region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
        weatherManager.fetchWeatherForGPS(lat: coords.latitude, lon: coords.longitude){
            result in
                switch result {
                case .success (let weather):
                    let gpsItem = AnnotationItem(coordinate: coords,
                                                 name: "My Location",
                                                 temp: weather.main.celcius,
                                                 sunrise: weather.sys.sunrise,
                                                 sunset: weather.sys.sunset,
                                                 dt: weather.dt
                    )
                    weatherManager.weatherFavCities.append(weather)
                    DispatchQueue.main.async {
                        self.annotationItems.append(gpsItem)
                        self.selectedAnnotationID = gpsItem.id
                    }
                   
                case .failure(let error):
                    print("Failed to fetch weather:\(error.localizedDescription)")
                    
                    
                }
            
            
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

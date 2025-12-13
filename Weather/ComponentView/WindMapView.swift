//
//  WindMapView.swift
//  Weather
//
//  Created by warbo on 12/12/25.
//

import SwiftUI
import MapKit
struct WindMapView: View {
    let locationWeather: WeatherModel
    let isFullScreen: Bool
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var annotationItems = [
        AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000))]
    func updateLocation(lat: Double,lon: Double){
       region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let annotation = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        annotationItems.removeAll()
        annotationItems.append(annotation)
        
   }
    var body: some View {
//        WeatherInfoCardView{
//            VStack{
//                HStack{
//                    Image(systemName: "wind")
//                    Text("WIND MAP")
//                        
//                        .modifier(LabelCardText())
//                    Spacer()
//                }
                
//        VStack{
            Map(
                coordinateRegion: $region ,
                annotationItems: annotationItems,
                annotationContent: { item in
                    MapMarker(coordinate: item.coordinate, tint: .blue)
                    
                }
            )
//        }
        
            .frame(width: isFullScreen ? .infinity : 280, height: isFullScreen ? .infinity : 300)
//            .frame(minHeight: isFullScreen ? .infinity : 200, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(maxWidth: isFullScreen ? .infinity : 400, maxHeight: isFullScreen ? .infinity : 400)
//            .frame(minHeight:0, maxHeight: 400)
//                .ignoresSafeArea(isFullScreen ? .all : [],edges: .all)
            
                .onAppear{
                    updateLocation(lat: locationWeather.coord.lat, lon: locationWeather.coord.lon)
                   
                }
                .cornerRadius(isFullScreen ? 0 : 10)
                .ignoresSafeArea(.all)
                
                .padding(isFullScreen ? 0 : 6)
//            }
//        }
    }
}

#Preview {
    WindMapView(locationWeather: WeatherModel.mock, isFullScreen: false)
}

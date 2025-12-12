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
        WeatherInfoCardView{
            VStack{
                HStack{
                    Image(systemName: "wind")
                    Text("WIND MAP")
                        
                        .modifier(LabelCardText())
                    Spacer()
                }
                
                Map(
                    coordinateRegion: $region ,
                    annotationItems: annotationItems,
                    annotationContent: { item in
                        MapMarker(coordinate: item.coordinate, tint: .blue)
                        
                    }
                )
                .onAppear{
                    updateLocation(lat: locationWeather.coord.lat, lon: locationWeather.coord.lon)
                   
                }
                .cornerRadius(10)
                .frame(minHeight: 200, maxHeight: 400)
                .padding(6)
            }
        }
    }
}

#Preview {
    WindMapView(locationWeather: WeatherModel.mock)
}

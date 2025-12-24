//
//  SheetAnnotationView.swift
//  Weather
//
//  Created by warbo on 20/12/25.
//

import SwiftUI
import CoreLocation
struct AnnotationListView: View {
    @Environment(\.dismiss) var dismiss
    let annotationItems: [AnnotationItem]
    let mode: MapDisplayMode
    @Binding var selectedID: UUID?
    var body: some View {
        VStack{
            HStack{
                Image(systemName: mode == .temperature ? "umbrella.fill" : "wind")
                    
                    .font(.system(size: 25,weight: .semibold))
                    
                VStack{
                    Text(mode == .temperature ? "Temperature" : "Wind Speed")
                        .font(.system(size: 18,weight: .semibold))
                    
                    Text("Your Location")
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30,weight: .semibold))
                        .foregroundStyle(.gray)
                }
                
            }
            .padding(20)
//            List{
//                ForEach($annotationItems){ city in
//                    HStack{
//                        Text("\(city.name)")
//                            .font(.system(size: 22))
//                        Text("\(city.temp)º")
//                            .font(.system(size: 22))
//                            .modifiers(LabelCardText())
//                    }
//                    
//                }
//            }
            
//            VStack{
                List(annotationItems, id: \.id) { item in
                    HStack{
                        VStack(alignment: .leading,spacing:6){
                            Text("\(item.name)")
                                .font(.system(size: 18))
                            if mode == .windSpeed {
                            Text( "\(item.windSpeed) mph, wind gust \(item.gust) mph")
                                    .font(.system(size:15))
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                        if mode == .windSpeed{
                            Image(systemName:"arrow.up")
                                .rotationEffect(.degrees(Double(item.windDeg + 180)))
                                .foregroundStyle(.secondary)
                        }
                       
                        Text(mode == .temperature ? "\(item.temp)º" : getWindDirection(degrees: item.windDeg))
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary)
                            .frame(width: 50)
    //                        .modifiers(LabelCardText())
                    }
//                    .padding(.horizontal,15)
                    
                    .onTapGesture {
                        selectedID = item.id
                        dismiss()
                    }
                }
                .listStyle(.plain)
                
                
                
                
                
                
                
                
            }
            
            
//        }
    }
}

#Preview {
    AnnotationListView(annotationItems: [AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Tan An", temp: 20, sunrise: 323, sunset: 323, dt: 323, windSpeed: 6, gust: 2, windDeg: 40),AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Thủ Thừa", temp: 20, sunrise: 323, sunset: 323, dt: 323, windSpeed: 6, gust: 2, windDeg: 343)], mode: .windSpeed, selectedID: .constant(nil))
}

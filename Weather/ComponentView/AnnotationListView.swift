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
    @Binding var selectedID: UUID?
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "umbrella.fill")
                    
                    .font(.system(size: 25,weight: .semibold))
                    
                VStack{
                    Text("Lượng Mưa")
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
            
            VStack{
                List(annotationItems, id: \.id) { item in
                    HStack{
                        Text("\(item.name)")
                            .font(.system(size: 18))
                        Spacer()
                        Text("\(item.temp)º")
                            .font(.system(size: 18))
                            .foregroundStyle(.secondary)
    //                        .modifiers(LabelCardText())
                    }
                    .onTapGesture {
                        selectedID = item.id
                        dismiss()
                    }
                }
                .listStyle(.plain)
            }
            .padding(.horizontal,20)
            
        }
    }
}

#Preview {
    AnnotationListView(annotationItems: [AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Tan An", temp: 20, sunrise: 323, sunset: 323, dt: 323),AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.23, longitude: 19.23), name: "Tan An", temp: 20, sunrise: 323, sunset: 323, dt: 323)], selectedID: .constant(nil))
}

//
//  WeatherDetailView .swift
//  Weather
//
//  Created by warbo on 20/11/25.
//

import SwiftUI
import MapKit

struct WeatherDetailView: View {
    // MARK: - PROPERTY
     var weather: WeatherModel
    @EnvironmentObject var weatherManager: WeatherManager
    @Environment(\.dismissModal) var dismissModal
    @Environment(\.dismiss) var dismiss
    
//    @State  var currentIndex: Int = 0
    @Binding var currentIndex: Int
    
    @State private var isScrollEnabled = true
    @State private var dragOffSet: CGFloat = 0
    @State private var currentScale: CGFloat = 1.0
    @State private var isDragging: Bool = false
    @State private var scrollOffset: CGFloat = 0
    // MARK: - Map View Property
    @State private var showingFullMap: Bool = false 
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//    @State private var annotationItems = [
//        AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000))
//        
//    ]
    let isPresentedAsSheet: Bool
    let collapseThreshold: CGFloat = 100
    let dismissThreshold: CGFloat = 100
    let maxScaleReduction: CGFloat = 0.9
    
    // Determine if the header should be in its collapsed state
    var isCollapsed: Bool{
        return scrollOffset < -collapseThreshold
    }

    let namespace: Namespace.ID
//    private let measurementFormatter: MeasurementFormatter = {
//       let formatter = MeasurementFormatter()
//        
//        return formatter
//    }()

    var isCityAdded: Bool{
        weatherManager.weatherFavCities.contains{ location in
            location.name == weather.name
            
        }
    }
    
    

    var body: some View {
        let screenHeight = UIScreen.main.bounds.height
        let dragRatio = min(1, dragOffSet / dismissThreshold)
        let calculatedScale = 1.0 - (1.0 - maxScaleReduction) * dragRatio
     // Drag View
        let drag = DragGesture()
            .onChanged{ gesture in
                let translation = gesture.translation.height
                isScrollEnabled = false
                if translation > 0 && currentScale > 0.3{
                    dragOffSet = translation
                    currentScale -= 0.01
                    isDragging = true
                }
                
            }
            .onEnded{ gesture in
                isDragging = false
                if gesture.translation.height > dismissThreshold{
//                    withAnimation(.easeOut(duration: 0.2)){
//                        dragOffSet = screenHeight
//                        currentScale = maxScaleReduction
//                        print(dragOffSet)
//                    }
                    dismissModal()
                }else{
                    withAnimation(.bouncy){
                        isScrollEnabled = true
                        dragOffSet = 0
                        currentScale = 1.0
                    }
                }
                
            }
        ZStack{
            
            
            Group{
                if isPresentedAsSheet{
                    SingleLocationContentView(isPresentedAsSheet: isPresentedAsSheet, showingFullMap: $showingFullMap, locationWeather: weather)
                        .background(
                            Image("\(weather.weather.first?.icon ?? "01d")")
                        )
                }else{
                    if weatherManager.weatherFavCities.isEmpty{
                        Text("No Favorite cities has been added yet!")
                    }else{
                        GeometryReader{ geo in
                            ZStack(alignment:.bottom){
                                //                VStack{
                                Image("\(weatherManager.weatherFavCities[currentIndex].weather.first?.icon ?? "01d")")
                                    .resizable()
                                    .scaledToFill()
                                
                                    .frame(maxWidth: geo.size.width,maxHeight: .infinity)
                                
                                //                    }
                                //                    .frame(maxWidth: geo.size.width)
                                TabView(selection:$currentIndex){
                                    ForEach(weatherManager.weatherFavCities.indices,id:\.self){ index in
                                        SingleLocationContentView(isPresentedAsSheet: isPresentedAsSheet, showingFullMap: $showingFullMap, locationWeather: weatherManager.weatherFavCities[index])
                                            
                                        //                                    .padding(.bottom,80)
                                            .tag(index)
                                            .id(index)
                                        
                                    }
                                    
                                    //Scroll View
                                    .scrollDisabled(!isScrollEnabled)
                                    //
                                }
                                .tabViewStyle(.page(indexDisplayMode: .never))
                                
                                
                                
                                FixedTapView(totalItems: weatherManager.weatherFavCities.count, showingFullMap: $showingFullMap, currentIndex: $currentIndex, dismissAction: dismissModal)
                                    .frame(height: 80)
                                    .background(.ultraThinMaterial)
                                    .colorScheme(.dark)
                                
                            }
                        
                            .cornerRadius(dragOffSet)
                            .scaleEffect(currentScale)
                            .offset(y:dragOffSet )
                            .gesture(drag)
                            .transition(.identity)
                            .ignoresSafeArea(.all)
                            
                        }
                       
                        
                    }
                        
                    
                }// Zstack of Swipable Content
            } // Group for sheet or full screen of WeatherDetailView
            if showingFullMap {
                            FullScreenMapView(locationWeather: weatherManager.weatherFavCities[currentIndex], isPresented: $showingFullMap)
                                .transition(.identity)
                        }
                
            
        } // Zstack of etire view
        
        
        
        
                    
                    
                }//:Zstack
        
                
            
        
    }



struct ScrollOffsetKey: PreferenceKey {
    // The default value if no preference is found
    static var defaultValue: CGFloat = 0.0
    
    // How to combine multiple preference values (not strictly necessary here, but required)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // We just take the latest reported value
        value = nextValue()
    }
}
struct DismissModalActionKey: EnvironmentKey{
    static let defaultValue: () -> Void = {}
}
extension EnvironmentValues {
    var dismissModal: () -> Void {
        get{self[DismissModalActionKey.self]}
        set{self[DismissModalActionKey.self] = newValue}
    }
}

#Preview {
    @Previewable @Namespace var previewNamespace
    let mockManager = WeatherManager()
    
    WeatherDetailView(weather: WeatherModel.mock, currentIndex: .constant(0), isPresentedAsSheet: false, namespace: previewNamespace)
        .environmentObject(mockManager)
}

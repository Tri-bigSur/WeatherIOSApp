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
    @State var weather: WeatherModel
    @EnvironmentObject var weatherManager: WeatherManager
    @Environment(\.dismiss) var dismiss
    @State private var dragOffSet: CGFloat = 0
    @State private var currentScale: CGFloat = 1.0
    
    @State private var scrollOffset: CGFloat = 0
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var annotationItems = [
        AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: 10.53589000, longitude: 106.41366000))
        
    ]
    let collapseThreshold: CGFloat = 100
    let dismissThreshold: CGFloat = 100
    let maxScaleReduction: CGFloat = 0.9
    
    // Determine if the header should be in its collapsed state
    var isCollapsed: Bool{
        return scrollOffset < -collapseThreshold
    }
    var currentHeading: Double = 180
    private let exclusionTolerance: Double = 7.0
    private let labelAngles: [Double] = [0.0,90.0,180.0,270]
    private let needleLength: CGFloat = 60
    private let needleThickness: CGFloat = 6
//    private let measurementFormatter: MeasurementFormatter = {
//       let formatter = MeasurementFormatter()
//        
//        return formatter
//    }()
     func updateLocation(lat: Double,lon: Double){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
         let annotation = AnnotationItem(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
         annotationItems.removeAll()
         annotationItems.append(annotation)
         
    }
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
                if translation > 0 && currentScale > 0.5{
                    dragOffSet = translation
                    currentScale -= 0.01
                }
                
            }
            .onEnded{ gesture in
                if gesture.translation.height > dismissThreshold{
                    withAnimation(.easeOut(duration: 0.2)){
                        dragOffSet = screenHeight
                        currentScale = maxScaleReduction
                        print(dragOffSet)
                    }
                    dismiss()
                }else{
                    withAnimation(.bouncy){
                        dragOffSet = 0
                        currentScale = 1.0
                    }
                }
                
            }
        
        
        
            ScrollView(.vertical,showsIndicators: false){
                GeometryReader { geometry in
                    Color.clear.preference(key: ScrollOffsetKey.self,
                                           value: geometry.frame(in: .named("scroll")).minY)
                }
                .frame(height: 0)
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
                            weatherManager.addFavCity(weather)
                            dismiss()
                           
                        }){
                            Text("Add")
                                .font(.system(size: 20,weight: .semibold))
                                .foregroundStyle(.white)
                                
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                    
                    

                }
                .padding(.horizontal,10)
                
                VStack{
                    Text(weather.name)
                        .font(.largeTitle)
                    
                    Text("\(weather.main.celcius)º")
                        .font(.system(size: 40,weight: .thin))
                    
                    Text(weather.weather.first?.weatherDescription ?? "Getting data...")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    HStack{
                        Text("H:\(weather.main.celciusMax)°")
                        Text("L:\(weather.main.celciusMin)°")
                    }
                    
                }
                
                
                .foregroundStyle(.white)
                Spacer()
                
                
                WeatherInfoCardView{
                    VStack(alignment:.leading,spacing: 10){
                        Text("Forecast it's rain at 5:00pm. Wind gust to 16 mph.")
                            .fontWeight(.regular)
                        Divider()
                            .overlay(.gray)
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:30){
                                
                                VStack(alignment:.center,spacing: 16){
                                    Text("Now")
                                        .fontWeight(.medium)
                                    VStack{
                                        Image(systemName: "cloud.fill")
                                            .font(.system(size: 20))
                                        
                                    }
                                    .frame(height: 25)
                                    
                                    
                                    
                                    Text("29°")
                                        .font(.system(size: 20,weight: .semibold))
                                    
                                }
                                
                                
                                
                                VStack(alignment:.center,spacing: 16){
                                    Text("11 am")
                                        .fontWeight(.medium)
                                    VStack{
                                        Image(systemName: "cloud.rain.fill")
                                            .font(.system(size: 20))
                                        
                                    }
                                    .frame(height: 25)
                                    
                                    
                                    
                                    Text("31°")
                                        .font(.system(size: 20,weight: .semibold))
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                }
                
                WeatherInfoCardView{
                    VStack{
                        HStack{
                            Image(systemName: "calendar")
                            Text("FORECAST IN 10 DAYS")
                                .modifier(LabelCardText())
                            Spacer()
                        }
                        
                        
                    }
                    
    //                ForEach(0..<7){ _ in
    //                    Divider()
    //                        .overlay(.gray)
    //                    DataWeatherRow(day: "Wednesday", icon: "cloud.fill", weatherTendency: "65%", lTemp: "22", hTemp: "31")
    //
    //
    //                }
                    Divider()
                        .overlay(.gray)
                    DailyWeatherRow(day: "Wednesday", icon: "cloud.drizzle.fill", weatherTendency: "", lTemp: "23", hTemp: "31")
                                        Divider()
                                            .overlay(.gray)
                                        
                    DailyWeatherRow(day: "Today", icon: "cloud.fill", weatherTendency: "65%", lTemp: "22", hTemp: "31")
                    
                                        Divider()
                                            .overlay(.gray)
                    DailyWeatherRow(day: "Thursday", icon: "cloud.fill", lTemp: "20", hTemp: "28")
                    
                    
                    
                    
                    
                }
               
                // MARK: - Map View
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
                            updateLocation(lat: weather.coord.lat, lon: weather.coord.lon)
                           
                        }
                        .cornerRadius(10)
                        .frame(minHeight: 200, maxHeight: 400)
                        .padding(6)
                    }
                }
                HStack(alignment: .top){
                    
                        WeatherInfoCardView{
                            HStack{
                                Image(systemName: "thermometer")
                                Text("FEELING")
                                    .modifier(LabelCardText())
                                Spacer()
                            }
                            
                            HStack{
                                VStack(alignment:.leading){
                                    Text("\(weather.main.celciusFeelsLike)")
                                        .modifier(TitleText())
                                        .padding(.vertical,7)
                                    Text("Wind is making you feel cooler when go outside")
                                    Spacer()
                                }
                                
                            }
                        }
                        
                        
                        WeatherInfoCardView{
                            HStack{
                                Image(systemName: "sun.max.fill")
                                Text("UV INDICATOR")
                                    .modifier(LabelCardText())
                                
                            }
                            
                            VStack(alignment:.leading){
                                Text("5")
                                    .modifier(TitleText())
                                    .padding(.top,2)
                                    
                                Text("Normal")
                                    .font(.system(size: 18,weight: .semibold))
                                Capsule()
                                    .frame(height: 4)
                                    .foregroundStyle(Color.multiColored)
                                    
                                Text("Avoiding sun shine until 16:00")
                            }
                        }
                        
                    
                }
                // MARK: - WIND SPEED
                WeatherInfoCardView{
                    HStack{
                        Image(systemName: "wind")
                        Text("Wind")
                            .modifier(LabelCardText())
                        Spacer()
                    }
                    HStack{
                        VStack{
                            HStack{
                                Text("Wind")
                                    .modifier(AnnotationText())
                                Spacer()
                                Text("\(weather.wind.mphSpeed) mph")
                                    .modifier(LabelCardText())
                            }
                            Divider()
                                .overlay(.gray)
                            HStack{
                                Text("Gust")
                                    .modifier(AnnotationText())
                                    
                                Spacer()
                                Text("\(weather.wind.mphGust) mph")
                                    .modifier(LabelCardText())
                            }
                            Divider()
                                .overlay(.gray)
                            HStack{
                                Text("Dimension")
                                    .modifier(AnnotationText())
                                Spacer()
                                Text("\(weather.wind.deg)")
                                    .modifier(LabelCardText())
                            }
                        }
                        // MARK: - COMPASS
                        //.1 TICK MARK
                        VStack{
                            ZStack{
                                Circle()
                                    .fill(.clear)
                                    
                                    
                                ForEach(0..<60){ i in
                                    let angleDegrees = Angle.degrees(Double(i) * (360.0/60.0))
                                    let isMajorTick = i % 5 == 0
                                    
                                    let shouldExclude = labelAngles.contains{ labelAngle in
                                        let diff = abs(angleDegrees.degrees - labelAngle)
                                        let wrappedDiff = min(diff, 360.0 - diff)
                                        
                                        return wrappedDiff < exclusionTolerance
                                        
                                    }
                                    if !shouldExclude{
                                        GaugeTickMark(
                                            startAngle: angleDegrees,
                                            endAngle: angleDegrees,
                                            length: isMajorTick ? 12 : 6,
                                            thickness: isMajorTick ? 2 : 1
                                        )
                                        .stroke(Color.white.opacity(0.7),lineWidth: isMajorTick ? 2 : 1)
                                    }
                                   
                                }
                                
                                Group{
                                    Text("E")
                                        .font(.system(size: 15))
                                        .modifier(LabelCardText())
                                        .offset(y:-60)
                                        .rotationEffect(.degrees(90))
                                    Text("S")
                                        .font(.system(size: 15))
                                        .modifier(LabelCardText())
                                        .offset(y:-60)
                                        .rotationEffect(.degrees(180))
                                    Text("W")
                                        .font(.system(size: 15))
                                        .modifier(LabelCardText())
                                        .offset(y:-60)
                                        .rotationEffect(.degrees(270))
                                        
                                }
                                Text("N")
                                    .font(.system(size: 15))
                                    .modifier(LabelCardText())
                                    .offset(y:-60)
                                
                                CompassNeedle()
                                    .fill(Color.white)
                                    .frame(width: needleThickness,height: needleLength*0.7)
                                    .offset(y:-45)
                                    .rotationEffect(.degrees(Double(180 + weather.wind.deg)))
                                CompassNeedle()
                                    .fill(Color.white)
                                    .frame(width: needleThickness,height: needleLength*0.7)
                                    .offset(y:-45)
                                    .rotationEffect(.degrees(Double(weather.wind.deg)))
                                VStack(spacing: 2){
                                    Text("\(weather.wind.mphSpeed)")
                                        .font(.system(size: 22,weight: .bold))
                                    Text("mph")
                                        .offset(y: -3)
                                        .font(.system(size: 10))
                                }
                                
                            }
                        }
                        .frame(width: 120,height: 120)
                        .padding(5)
                        
                        
                        
                    }
                    
                }
                
                HStack(alignment:.top){
                    WeatherInfoCardView{
                        HStack{
                           Image(systemName: "eye.fill")
                           Text("FORESIGHT")
                                .modifier(LabelCardText())
                            Spacer()
                            
                        }
                        HStack{
                            VStack(alignment:.leading){
                                Text("\(weather.visibilityInMiles) miles")
                                    .modifier(TitleText())
                                    .padding(.vertical,5)
                                Text("Foresight is completely clear.")
                            }
                            Spacer()
                        }
                    }

                    
                    WeatherInfoCardView{
                        HStack{
                            Image(systemName: "humidity.fill")
                            Text("HUMIDITY")
                                .modifier(LabelCardText())
                                .padding(.vertical,5)
                            Spacer()
                            
                        }
                        VStack(alignment:.leading){
                            Text("\(weather.main.humidity)%")
                                .modifier(TitleText())
                                .padding(.vertical,5)
                                
                            
                            Text("Dew point is 16º at this time.")
                            Spacer()
                        }
                        
                    }

                }

                            
                            }
            
        //Scroll View
        
//                    .coordinateSpace(name: "scroll")
//                    .onPreferenceChange(ScrollOffsetKey.self) { value in
//                        // 3. Update the state with the new scroll offset
//                        scrollOffset = value
//                    }
//        }
                    .scaleEffect(currentScale)
                    .offset( y:dragOffSet)
                    .gesture(drag)
                    .background(
                        Image("\(weather.weather.first?.icon ?? "01d")")
                    )
                    
                    
                }//:Zstack
        
                
            
        
    }

struct AnnotationItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
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

#Preview {
    let mockmanager = WeatherManager()
    WeatherDetailView(weather: WeatherModel.mock)
        .environmentObject(mockmanager)
}

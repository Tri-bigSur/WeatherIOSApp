//
//  ContentView.swift
//  Weather
//
//  Created by warbo on 12/11/25.
//

import SwiftUI

struct HomeView: View {
    //PROPERTY
    private let weatherService = WeatherAPIService()
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var searchedLocation: WeatherModel? = nil
    @State private var selectedLocation: WeatherModel? = nil
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @State private var showingSheet: Bool = false
    @State private var errorMessage: String? = nil
    @Environment(\.isSearching) private var isSearching
    @State private var weatherStatic:WeatherModel = WeatherModel.mock
    @StateObject private var searchService = LocationSearchService()
    @Namespace var animation
    
//    var filteredSuggestion: [String]{
//        if searchText.isEmpty{
//            return [""]
//        }else{
//            return allCities.filter{$0.localizedCaseInsensitiveContains(searchText)}
//        }
//        
//    }
    
    // MARK: - DELETE ITEM OF LIST
    func searchWeatherCity(city: String){
        weatherManager.fetchLocationForSheet(city: city){
            result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newLocation):
                    self.searchedLocation = newLocation
                    
                    self.errorMessage = nil
                case . failure(let error):
                    self.searchedLocation = nil
                    
                    self.errorMessage = "Failed to fetch weather:\(error.localizedDescription)"
                    
                }
                
            }
            
        }
    }
    func findCityCard(city: String){
        weatherManager.fetchLocationForSheet(city: city){
            result in
            DispatchQueue.main.async{
                switch result {
                case .success(let newLocation):
                    self.selectedLocation = newLocation
                    self.errorMessage = nil
                case .failure(let error):
                    self.selectedLocation = nil
                    self.errorMessage = "Failed to fetch weather:\(error.localizedDescription)"
                    
                }
            }
        }
    }
    
    func deleteItem(at offsets: IndexSet ){
        weatherManager.weatherFavCities.remove(atOffsets: offsets)
    }
    // BODY
    var body: some View {
        
        ZStack{
            NavigationView{
                
                
                List {
                    
                    
                    ForEach(weatherManager.weatherFavCities){ weatherItem in
                        
                        WeatherCardView(weatherData: weatherItem,nameSpace: animation, isModal: selectedLocation?.name == weatherItem.name)
                            .onTapGesture {
                                withAnimation(.easeOut){
                                    findCityCard(city: weatherItem.name)
                                }
                               
                                
                                
                            }
                        
                        
                        //                                                                    .padding()
                        
                        //                                                if let weather = weatherService.weatherData {
                        //                                                                // Pass the single object directly to the view
                        //
                        //                                                            } else {
                        //                                                                Text("Enter a city name to search for weather.")
                        //                                                                    .foregroundColor(.gray)
                        //                                                            }
                        //
                        //
                    }
                    //
                    //
                    .onDelete(perform: deleteItem)
                    .listRowSeparator(.hidden)
                    //                    }
                   
                    
                    
                    
                    
                }
                .refreshable{
                    weatherManager.refreshAllWeather()
                }
                .listStyle(.plain)
                .blur(radius: isSearchFocused ? 10: 0)
                .overlay {
                    if isSearchFocused {
                        Color.black.opacity(0.15).ignoresSafeArea(.all)
                        // Note: You may not need the onTapGesture here,
                        // as the system's "Cancel" button handles dismissal.
                    }
                }
                .navigationTitle("Weather")
                
                // search bar
                .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always),prompt: "Search name of city/airport"){
                    ForEach(searchService.completions,id:\.self){ completion in
                        Text(completion.title)
                            .searchCompletion(completion.title)
                            .foregroundStyle(.primary)
                            .onTapGesture {
                                searchText = completion.title
                                self.showingSheet = true
                                self.searchWeatherCity(city: searchText)
                                
                            }
                        
                    }
                }
                
                // update search service every time search text change
                .onChange(of: searchText){ oldValue, newValue in
                    searchService.updateQuery(fragment: newValue)
                }
                .focused($isSearchFocused)
                
            }
            .sheet(isPresented: $showingSheet){
                if let location = searchedLocation{
                    WeatherDetailView(weather: location, isPresentedAsSheet: true, namespace: animation )
                }else{
                    Text("Fetching Weather...")
                }
            }
            if let location = selectedLocation {
                WeatherDetailView(weather: location, isPresentedAsSheet: false, namespace: animation)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .environment(\.dismissModal){
                        withAnimation(.easeOut){
                            self.selectedLocation = nil
                        }
                    }
                
            }
        }
        
       
            
            
            
        
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
    let mockmanager = WeatherManager()
    HomeView()
        .environmentObject(mockmanager)
}

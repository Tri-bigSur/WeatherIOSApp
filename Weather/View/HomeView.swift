//
//  ContentView.swift
//  Weather
//
//  Created by warbo on 12/11/25.
//

import SwiftUI

struct HomeView: View {
    //PROPERTY
    @StateObject var weatherService = WeatherAPIService()
    @EnvironmentObject var weatherManager: WeatherManager
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @State private var showingSheet: Bool = false
    @Environment(\.isSearching) private var isSearching
    @State private var weatherStatic:WeatherModel = WeatherModel.mock
    @StateObject private var searchService = LocationSearchService()
    
//    var filteredSuggestion: [String]{
//        if searchText.isEmpty{
//            return [""]
//        }else{
//            return allCities.filter{$0.localizedCaseInsensitiveContains(searchText)}
//        }
//        
//    }
    
    // MARK: - DELETE ITEM OF LIST
    func deleteItem(at offsets: IndexSet ){
        weatherManager.weatherFavCities.remove(atOffsets: offsets)
    }
    // BODY
    var body: some View {
        
            NavigationView{
               
                        
                                            List {
                                                
                        
                                                ForEach(weatherManager.weatherFavCities){ weatherItem in
                                                    
                                                    WeatherCardView(weatherData: weatherItem)
                                                    
                                                    
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
                                .foregroundStyle(.black)
                                .onTapGesture {
                                    searchText = completion.title
                                    weatherService.fetchWeatherData(for: searchText)
                                    showingSheet = true
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
                if let weather = weatherService.weatherData{
                    WeatherDetailView(weather: weather)
                }else{
                    Text("Fetching Weather...")
                }
            }
            
            
            
        
    }
}

#Preview {
    let mockmanager = WeatherManager()
    HomeView()
        .environmentObject(mockmanager)
}

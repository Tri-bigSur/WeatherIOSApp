//
//  LocationSearchService.swift
//  Weather
//
//  Created by warbo on 19/11/25.
//

import Foundation
import MapKit

class LocationSearchService: NSObject,ObservableObject,MKLocalSearchCompleterDelegate {
    @Published var completions: [MKLocalSearchCompletion] = []
    
    //Search object engine
    private lazy var completer: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        completer.resultTypes = .address
        return completer
    }()
    
    // Receive search text from content view
    func updateQuery(fragment: String){
        completer.queryFragment = fragment
    }
    // MARK: - MKLocalSearchCompleterDelegate methods
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        //Update the puplished property on the main thread
        DispatchQueue.main.async {
            self.completions = completer.results
        }
    }
    
    // handle when search fail
    private func completer(_ completer: MKLocalSearchCompleter, didFaifWithError error: Error){
        print("Search failed with error:\(error.localizedDescription)")
    }
    
}

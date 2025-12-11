//
//  WeatherInfoCardView.swift
//  Weather
//
//  Created by warbo on 22/11/25.
//

import SwiftUI

struct WeatherInfoCardView<Content: View>: View {
    let content: Content
    // The initializer accpepts a closure that returns a view
    init(@ViewBuilder content:() -> Content) {
        self.content = content()
    }
    var body: some View {
        HStack{
            VStack{
                content // the injected content goes here
                    .padding(20)
            }
        }
        .padding(.vertical,10)
        .background(
            RoundedRectangle(cornerRadius: 15) // Creates the card shape
                .fill(.ultraThinMaterial)
        )
        .colorScheme(.dark)
        .padding(.horizontal,16)
    }
}



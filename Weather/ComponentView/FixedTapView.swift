//
//  FixedTapView.swift
//  Weather
//
//  Created by warbo on 11/12/25.
//

import SwiftUI

struct FixedTapView: View {
    var totalItems: Int
    
    var body: some View {
        HStack(alignment:.center){
            Image(systemName: "map")
                .foregroundStyle(.white)
                .font(.system(size: 25,weight: .semibold))
            Spacer()
            ForEach(1..<totalItems + 1, id: \.self){_ in
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "list.bullet")
                .foregroundStyle(.white)
                .font(.system(size: 25,weight: .semibold))
        }
        .padding(.bottom,20)
        .padding(.horizontal,15)
    }
}

#Preview {
    FixedTapView(totalItems: 3)
}

//
//  FixedTapView.swift
//  Weather
//
//  Created by warbo on 11/12/25.
//

import SwiftUI

struct FixedTapView: View {
    var totalItems: Int
    private let activeColor: Color = .white
    private let inActiveColor: Color = .gray
    @Binding var showingFullMap: Bool
    @Binding var currentIndex: Int
    let dismissAction: () -> Void
    var body: some View {
        HStack(alignment:.center){
            Button{
                showingFullMap = true
            }label:{
                Image(systemName: "map")
                    .foregroundStyle(.white)
                    .font(.system(size: 25,weight: .semibold))
            }
            
            Spacer()
            ForEach(0..<totalItems, id: \.self){ index in
                let dotColor = index == currentIndex ? Color.white : Color.gray
                Image(systemName: "circle.fill")
                    .font(.system(size: 8))
                    .foregroundColor(dotColor)
                    .onTapGesture {
                        currentIndex = index
                    }
            }
            Spacer()
            Button{
                dismissAction()
            }label: {
                Image(systemName: "list.bullet")
                    .foregroundStyle(.white)
                    .font(.system(size: 25,weight: .semibold))
            }
           
        }
        .padding(.bottom,20)
        .padding(.horizontal,15)
        
    }
}

#Preview {
    FixedTapView(totalItems: 3, showingFullMap: .constant(false), currentIndex: .constant(1), dismissAction: {})
}

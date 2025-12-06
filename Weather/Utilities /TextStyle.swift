//
//  TextStyle.swift
//  Weather
//
//  Created by warbo on 28/11/25.
//

import SwiftUI

struct LabelCardText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.secondary)
            .fontWeight(.medium)
            
    }
}
struct TitleText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20,weight: .regular))
            
    }
}
struct AnnotationText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16,weight: .medium))
    }
}
struct ScaleButtonStyle: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0 )
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

//
//  StyleModifiers.swift
//  Doc App
//
//  Created by Lugardo JC on 16/10/24.
//
import SwiftUI

struct RoundedBorders: ViewModifier {
    var opacity: Double = 0.5
    var cornerRadius : Double = 15.0
    var color : Color = .gray
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .inset(by: 0.5)
                    .stroke(lineWidth: 1.0)
                    .opacity(opacity)
                    .allowsHitTesting(false)
                    .foregroundStyle(color)
            }
            .cornerRadius(cornerRadius)
    }
}

struct RoundedBorderDash: ViewModifier {
    var opacity: Double = 0.5
    var color : Color = .gray
    var cornerRadius : Double = 15.0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius).inset(by: 0.5).stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    .foregroundStyle(color)
                    .allowsHitTesting(false)
            }
            .cornerRadius(15)
    }
}


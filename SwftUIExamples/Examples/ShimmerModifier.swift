//
//  ShimmerModifier.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - ShimmerModifier

struct ShimmerModifier: ViewModifier {

    var isActive: Bool
    var duration: Double
    // Grados de inclinación de la barra desde la vertical.
    // 0 = barra vertical recta, positivo = la parte superior se inclina a la derecha.
    var angle: Double

    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        // Calcular startPoint/endPoint en función del ángulo.
        // La fórmula garantiza que la barra siempre barre de izquierda a derecha
        // sin importar la inclinación, y que el gradiente cubra toda la vista.
        // Clamp: más allá de ±80° cosA ≈ 0 y el eje horizontal del sweep desaparece.
        let safeAngle = max(-80, min(80, angle))
        let rad  = CGFloat(safeAngle) * .pi / 180
        let cosA = cos(rad)
        let sinA = sin(rad)
        // "span" es la longitud mínima del vector gradiente para cubrir el cuadro unitario.
        let span   = abs(cosA) + abs(sinA)
        let center = phase + 0.5   // centro de la barra (va de -0.5 a 1.5)

        let start = UnitPoint(x: center - span * cosA / 2,
                              y: 0.5    - span * sinA / 2)
        let end   = UnitPoint(x: center + span * cosA / 2,
                              y: 0.5    + span * sinA / 2)

        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .white.opacity(0),    location: 0.0),
                        .init(color: .white.opacity(0),    location: 0.35),
                        .init(color: .white.opacity(0.25), location: 0.45),
                        .init(color: .white.opacity(0.45), location: 0.50),
                        .init(color: .white.opacity(0.25), location: 0.55),
                        .init(color: .white.opacity(0),    location: 0.65),
                        .init(color: .white.opacity(0),    location: 1.0)
                    ]),
                    startPoint: start,
                    endPoint:   end
                )
                // Recortar el overlay al shape exacto del contenido.
                .mask(content)
            )
            .onAppear {
                guard isActive else { return }
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

// MARK: - View extension

extension View {
    /// Aplica un barrido de brillo de izquierda a derecha sobre cualquier vista.
    /// - Parameters:
    ///   - isActive:  `false` para desactivar (p.ej. cuando los datos cargan).
    ///   - duration:  Segundos de un barrido completo. Default `1.5`.
    ///   - angle:     Inclinación de la barra en grados desde la vertical (máx recomendado ±30°). Default `0`.
    func shimmering(isActive: Bool = true, duration: Double = 1.5, angle: Double = 0) -> some View {
        modifier(ShimmerModifier(isActive: isActive, duration: duration, angle: angle))
    }
}

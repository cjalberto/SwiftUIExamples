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
    var delay: Double
    var angle: Double

    @State private var phase: CGFloat = -1
    @State private var task: Task<Void, Never>? = nil

    func body(content: Content) -> some View {
        let safeAngle = max(-80, min(80, angle))
        let rad  = CGFloat(safeAngle) * .pi / 180
        let cosA = cos(rad)
        let sinA = sin(rad)
        let span   = abs(cosA) + abs(sinA)
        let center = phase + 0.5

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
                .mask(content)
            )
            .onAppear {
                guard isActive else { return }
                startLoop()
            }
            .onDisappear {
                cancelLoop()
            }
            .onChange(of: duration) { startLoop() }
            .onChange(of: delay)    { startLoop() }
            .onChange(of: isActive) { isActive ? startLoop() : cancelLoop() }
    }

    // MARK: - Loop

    private func startLoop() {
        cancelLoop()
        task = Task { @MainActor in
            while !Task.isCancelled {
                // Snap al inicio sin animación
                snap(to: -1)

                // Una pasada de izquierda a derecha
                withAnimation(.linear(duration: duration)) {
                    phase = 1
                }

                // Esperar a que termine la pasada + el delay configurado
                try? await Task.sleep(for: .seconds(duration + delay))
            }
        }
    }

    private func cancelLoop() {
        task?.cancel()
        task = nil
        snap(to: -1)
    }

    private func snap(to value: CGFloat) {
        var t = Transaction()
        t.disablesAnimations = true
        withTransaction(t) { phase = value }
    }
}

// MARK: - View extension

extension View {
    /// Aplica un barrido de brillo de izquierda a derecha sobre cualquier vista.
    /// - Parameters:
    ///   - isActive:  `false` para desactivar (p.ej. cuando los datos cargan).
    ///   - duration:  Duración de una pasada en segundos. Default `1.5`.
    ///   - delay:     Pausa entre pasadas en segundos. Default `0`.
    ///   - angle:     Inclinación de la barra desde la vertical, en grados (máx ±80°). Default `0`.
    func shimmering(
        isActive: Bool = true,
        duration: Double = 1.5,
        delay: Double = 0,
        angle: Double = 0
    ) -> some View {
        modifier(ShimmerModifier(isActive: isActive, duration: duration, delay: delay, angle: angle))
    }
}

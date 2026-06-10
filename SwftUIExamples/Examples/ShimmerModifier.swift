//
//  ShimmerModifier.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - ShimmerModifier

struct ShimmerModifier: ViewModifier {

    // MARK: - Properties

    var isActive: Bool
    var duration: Double
    var delay: Double
    var angle: Double
    /// Visual width of the shimmer band as a fraction of the view (0…1). Default `0.3`.
    var width: Double
    /// Color of the shimmer band. Default `.white`.
    var color: Color

    @State private var phase: CGFloat = -1
    @State private var task: Task<Void, Never>? = nil

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(shimmerOverlay(for: content))
            .onAppear     { guard isActive else { return }; startLoop() }
            .onDisappear  { cancelLoop() }
            .onChange(of: duration) { startLoop() }
            .onChange(of: delay)    { startLoop() }
            .onChange(of: isActive) { isActive ? startLoop() : cancelLoop() }
    }

    // MARK: - Gradient

    /// Builds the shimmer overlay clipped to the shape of the content.
    @ViewBuilder
    private func shimmerOverlay(for content: Content) -> some View {
        LinearGradient(
            gradient: Gradient(stops: gradientStops()),
            startPoint: gradientStart,
            endPoint:   gradientEnd
        )
        .mask(content)
    }

    /// `startPoint` of the gradient for the current phase and angle.
    private var gradientStart: UnitPoint {
        let (cosA, sinA, span) = angleComponents
        let center = phase + 0.5
        return UnitPoint(x: center - span * cosA / 2,
                         y: 0.5    - span * sinA / 2)
    }

    /// `endPoint` of the gradient for the current phase and angle.
    private var gradientEnd: UnitPoint {
        let (cosA, sinA, span) = angleComponents
        let center = phase + 0.5
        return UnitPoint(x: center + span * cosA / 2,
                         y: 0.5    + span * sinA / 2)
    }

    /// Returns `(cosA, sinA, span)` for the clamped angle.
    /// `span` is the minimum gradient vector length needed to cover the full view.
    private var angleComponents: (cosA: CGFloat, sinA: CGFloat, span: CGFloat) {
        let safeAngle = max(-80, min(80, angle))
        let rad  = CGFloat(safeAngle) * .pi / 180
        let cosA = cos(rad)
        let sinA = sin(rad)
        let span = abs(cosA) + abs(sinA)
        return (cosA, sinA, span)
    }

    /// Builds gradient stops, scaling `bandHalf` to compensate for the angle.
    /// Without this correction, tilting the band causes `cos(angle) → 0`,
    /// making the band appear progressively thinner on screen.
    private func gradientStops() -> [Gradient.Stop] {
        let (cosA, _, span) = angleComponents
        let clampedWidth = CGFloat(max(0, min(1, width)))
        let bandHalf = min(clampedWidth / max(2 * span * abs(cosA), 0.001), 0.45)

        return [
            .init(color: color.opacity(0),    location: 0),
            .init(color: color.opacity(0),    location: 0.5 - bandHalf),
            .init(color: color.opacity(0.25), location: 0.5 - bandHalf * 0.4),
            .init(color: color.opacity(0.45), location: 0.5),
            .init(color: color.opacity(0.25), location: 0.5 + bandHalf * 0.4),
            .init(color: color.opacity(0),    location: 0.5 + bandHalf),
            .init(color: color.opacity(0),    location: 1),
        ]
    }

    // MARK: - Animation Loop

    /// Cancels any running loop and starts a new one with the current parameters.
    private func startLoop() {
        cancelLoop()
        task = Task { @MainActor in
            while !Task.isCancelled {
                snap(to: -1)
                withAnimation(.linear(duration: duration)) { phase = 1 }
                try? await Task.sleep(for: .seconds(duration + delay))
            }
        }
    }

    /// Cancels the loop and resets the phase without animation.
    private func cancelLoop() {
        task?.cancel()
        task = nil
        snap(to: -1)
    }

    /// Moves `phase` to the given value with no animated transition.
    private func snap(to value: CGFloat) {
        var t = Transaction()
        t.disablesAnimations = true
        withTransaction(t) { phase = value }
    }
}

// MARK: - View Extension

extension View {
    /// Applies a left-to-right shimmer sweep over any SwiftUI view.
    /// - Parameters:
    ///   - isActive:  Set to `false` to stop the effect (e.g. once data has loaded). Default `true`.
    ///   - duration:  Duration of a single pass in seconds. Default `1.5`.
    ///   - delay:     Pause between passes in seconds. Default `0`.
    ///   - angle:     Band tilt from vertical in degrees (clamped to ±80°). Default `0`.
    ///   - width:     Visual width of the band as a fraction of the view (0…1). Default `0.3`.
    ///   - color:     Color of the shimmer band. Default `.white`.
    func shimmering(
        isActive: Bool   = true,
        duration: Double = 1.5,
        delay: Double    = 0,
        angle: Double    = 0,
        width: Double    = 0.3,
        color: Color     = .white
    ) -> some View {
        modifier(ShimmerModifier(
            isActive: isActive,
            duration: duration,
            delay:    delay,
            angle:    angle,
            width:    width,
            color:    color
        ))
    }
}

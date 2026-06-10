//
//  ShimmerExampleView.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - ShimmerExampleView

struct ShimmerExampleView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                ShimmerRectRow(label: "Azul",    color: .blue)
                ShimmerRectRow(label: "Morado",  color: .purple)
                ShimmerRectRow(label: "Verde",   color: .green)
                ShimmerRectRow(label: "Naranja", color: .orange)
            }
            .padding()
        }
        .navigationTitle("Shimmer Effect")
    }
}

// MARK: - ShimmerRectRow

private struct ShimmerRectRow: View {

    let label: String
    let color: Color

    @State private var angle: Double    = 20
    @State private var duration: Double = 1.0
    @State private var delay: Double    = 0.0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Rectángulo con shimmer
            RoundedRectangle(cornerRadius: 16)
                .fill(color)
                .frame(height: 90)
                .shimmering(duration: duration, delay: delay, angle: angle)

            // Slider de ángulo
            VStack(alignment: .leading, spacing: 2) {
                Text("\(label) — Ángulo: \(Int(angle))°")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Slider(value: $angle, in: -90...90, step: 1)
                    .tint(color)
            }

            // Slider de duración
            VStack(alignment: .leading, spacing: 2) {
                Text("Duración: \(String(format: "%.1f", duration)) s")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Slider(value: $duration, in: 0.1...6.0, step: 0.1)
                    .tint(color)
            }

            // Slider de delay
            VStack(alignment: .leading, spacing: 2) {
                Text("Delay: \(String(format: "%.1f", delay)) s")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Slider(value: $delay, in: 0.0...3.0, step: 0.1)
                    .tint(color)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ShimmerExampleView()
    }
}

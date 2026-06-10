//
//  ShimmerExampleView.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - ShimmerExampleView

struct ShimmerExampleView: View {

    @State private var isLoading = true
    @State private var angle: Double = 20

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {

                // ── Slider para ajustar el ángulo en tiempo real ──────────────
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ángulo: \(Int(angle))°")
                        .font(.headline)
                    Slider(value: $angle, in: -45...45, step: 1)
                        .tint(.blue)
                }

                // ── 1. Rectángulo (azul) ──────────────────────────────────────
                sectionHeader("Rectangle · \(Int(angle))°")
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(height: 100)
                    .shimmering(isActive: isLoading, angle: angle)

                // ── 2. Círculo + líneas (morado) ──────────────────────────────
                sectionHeader("Circle · \(Int(angle))°")
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color.purple.opacity(0.30))
                        .frame(width: 72, height: 72)
                        .shimmering(isActive: isLoading, angle: angle)

                    VStack(alignment: .leading, spacing: 8) {
                        shimmerLine(width: 160, color: .purple)
                        shimmerLine(width: 110, color: .purple)
                    }
                }

                // ── 3. Barra de progreso (verde) ──────────────────────────────
                sectionHeader("Progress bar · \(Int(angle))°")
                VStack(alignment: .leading, spacing: 8) {
                    shimmerLine(width: 200, color: .green)
                    Capsule()
                        .fill(Color.green.opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .frame(height: 12)
                        .shimmering(isActive: isLoading, duration: 1.0, angle: angle)
                }

                // ── 4. Card tipo Ontop ────────────────────────────────────────
                sectionHeader("Card · \(Int(angle))°")
                ontopCard

                Divider()

                // ── Toggle ────────────────────────────────────────────────────
                Button {
                    withAnimation { isLoading.toggle() }
                } label: {
                    Label(
                        isLoading ? "Detener shimmer" : "Iniciar shimmer",
                        systemImage: isLoading ? "stop.circle" : "play.circle"
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isLoading ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Shimmer Effect")
    }

    // MARK: - Subviews

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(.secondary)
    }

    private func shimmerLine(width: CGFloat, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(color.opacity(0.25))
            .frame(width: width, height: 14)
            .shimmering(isActive: isLoading, angle: angle)
    }

    // Card similar a la imagen de referencia: fondo oscuro, ícono, texto y shimmer inclinado.
    private var ontopCard: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.indigo.opacity(0.6))
                .frame(width: 56, height: 56)
                .overlay(Image(systemName: "creditcard.fill").foregroundStyle(.white))

            VStack(alignment: .leading, spacing: 4) {
                Text("Get physical card")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Get most of your Visa card")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            Image(systemName: "arrow.right.circle.fill")
                .foregroundStyle(.white.opacity(0.8))
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color(white: 0.15), Color(white: 0.22)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
        .shimmering(isActive: isLoading, duration: 2.0, angle: angle)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ShimmerExampleView()
    }
}

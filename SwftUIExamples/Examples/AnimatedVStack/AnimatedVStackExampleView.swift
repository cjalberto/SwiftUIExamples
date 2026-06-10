//
//  AnimatedVStackExampleView.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - AnimatedVStackExampleView

struct AnimatedVStackExampleView: View {

    // MARK: - Properties

    @State private var stackID = UUID()
    @State private var duration: Double = 0.45
    @State private var staggerDelay: Double = 0.45
    @State private var slideOffset: Double = 36

    private let cards: [DemoCard] = [
        DemoCard(color: .blue,   title: "First"),
        DemoCard(color: .purple, title: "Second"),
        DemoCard(color: .green,  title: "Third"),
        DemoCard(color: .orange, title: "Fourth"),
        DemoCard(color: .red,    title: "Fifth"),
    ]

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                animatedStack
                controls
            }
            .padding()
        }
        .navigationTitle("Animated VStack")
    }

    // MARK: - Subviews

    private var animatedStack: some View {
        AnimatedVStack(
            cards,
            spacing: 12,
            duration: duration,
            staggerDelay: staggerDelay,
            slideOffset: CGFloat(slideOffset)
        ) { card in
            RoundedRectangle(cornerRadius: 14)
                .fill(card.color)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .overlay(
                    Text(card.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                )
        }
        .id(stackID)
    }

    private var controls: some View {
        VStack(spacing: 16) {
            Button {
                stackID = UUID()
            } label: {
                Label("Replay", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            GroupBox {
                VStack(spacing: 12) {
                    sliderRow(
                        label: "Duration: \(String(format: "%.2f", duration)) s",
                        value: $duration,
                        range: 0.1...1.5,
                        step: 0.05
                    )
                    sliderRow(
                        label: "Stagger delay: \(String(format: "%.2f", staggerDelay)) s",
                        value: $staggerDelay,
                        range: 0.0...0.5,
                        step: 0.01
                    )
                    sliderRow(
                        label: "Slide offset: \(Int(slideOffset)) pt",
                        value: $slideOffset,
                        range: 0...80,
                        step: 1
                    )
                }
            } label: {
                Label("Parameters", systemImage: "slider.horizontal.3")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func sliderRow(
        label: String,
        value: Binding<Double>,
        range: ClosedRange<Double>,
        step: Double
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Slider(value: value, in: range, step: step)
        }
    }
}

// MARK: - DemoCard

private struct DemoCard: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AnimatedVStackExampleView()
    }
}

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
    @State private var selectedOption: EntranceOption = .topDown
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
        .onChange(of: selectedOption) { _, _ in stackID = UUID() }
    }

    // MARK: - Subviews

    private var animatedStack: some View {
        AnimatedVStack(
            cards,
            entrance: selectedOption.makeEntrance(duration: duration, staggerDelay: staggerDelay),
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
        GroupBox {
            VStack(spacing: 12) {
                Picker("Entrance", selection: $selectedOption) {
                    ForEach(EntranceOption.allCases) { option in
                        Text(option.label).tag(option)
                    }
                }
                .pickerStyle(.menu)

                sliderRow(
                    label: "Duration: \(String(format: "%.2f", duration)) s",
                    value: $duration, range: 0.1...1.5, step: 0.05
                )
                sliderRow(
                    label: "Stagger delay: \(String(format: "%.2f", staggerDelay)) s",
                    value: $staggerDelay, range: 0.0...1.0, step: 0.01
                )
                sliderRow(
                    label: "Slide offset: \(Int(slideOffset)) pt",
                    value: $slideOffset, range: 0...80, step: 1
                )

                Button {
                    stackID = UUID()
                } label: {
                    Label("Replay", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        } label: {
            Label("Controls", systemImage: "slider.horizontal.3")
                .font(.subheadline)
                .foregroundStyle(.secondary)
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

// MARK: - EntranceOption

private enum EntranceOption: CaseIterable, Identifiable {
    case topDown, bottomUp, leading, trailing, mixed

    var id: Self { self }

    var label: String {
        switch self {
        case .topDown:  "Top Down"
        case .bottomUp: "Bottom Up"
        case .leading:  "Leading"
        case .trailing: "Trailing"
        case .mixed:    "Mixed (per-item)"
        }
    }

    func makeEntrance(duration: Double, staggerDelay: Double) -> any StackEntrance {
        let anim = Animation.easeOut(duration: duration)
        switch self {
        case .topDown:  return TopDownEntrance(animation: anim, staggerDelay: staggerDelay)
        case .bottomUp: return BottomUpEntrance(animation: anim, staggerDelay: staggerDelay)
        case .leading:  return LeadingEntrance(animation: anim, staggerDelay: staggerDelay)
        case .trailing: return TrailingEntrance(animation: anim, staggerDelay: staggerDelay)
        case .mixed:    return MixedEntrance(duration: duration, staggerDelay: staggerDelay)
        }
    }
}

// MARK: - MixedEntrance

private struct MixedEntrance: StackEntrance {
    var duration: Double
    var staggerDelay: Double

    func animation(for index: Int, total: Int) -> Animation {
        switch index % 3 {
        case 0: .spring(duration: duration, bounce: 0.4)
        case 1: .easeOut(duration: duration * 0.9)
        default: .spring(duration: duration * 1.1, bounce: 0.2)
        }
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        switch index % 3 {
        case 0: CGSize(width: 0, height: -amount)  // desde arriba
        case 1: CGSize(width: 0, height: amount)   // desde abajo
        default: CGSize(width: -amount, height: 0) // desde la izquierda
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

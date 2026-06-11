//
//  AnimatedStackExampleView.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - AnimatedStackExampleView

struct AnimatedStackExampleView: View {

    // MARK: - Properties

    let axis: Axis

    @State private var stackID = UUID()
    @State private var selectedOption: EntranceOption
    @State private var duration: Double = 0.45
    @State private var staggerDelay: Double = 0.45
    @State private var slideOffset: Double = 36
    @State private var animationCompleted = false

    private let cards: [DemoCard] = [
        DemoCard(color: .blue,   title: "First"),
        DemoCard(color: .purple, title: "Second"),
        DemoCard(color: .green,  title: "Third"),
        DemoCard(color: .orange, title: "Fourth"),
        DemoCard(color: .red,    title: "Fifth"),
    ]

    init(axis: Axis) {
        self.axis = axis
        _selectedOption = State(initialValue: axis == .vertical ? .topDown : .leading)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                animatedStack
                completionBadge
                controls
            }
            .padding()
        }
        .navigationTitle(axis == .vertical ? "Animated VStack" : "Animated HStack")
        .onChange(of: selectedOption) { _, _ in replay() }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var animatedStack: some View {
        let stack = AnimatedStack(
            cards,
            axis: axis,
            entrance: selectedOption.makeEntrance(duration: duration, staggerDelay: staggerDelay),
            slideOffset: CGFloat(slideOffset)
        ) { card in
            RoundedRectangle(cornerRadius: 14)
                .fill(card.color)
                .frame(
                    width:  axis == .horizontal ? 100 : nil,
                    height: axis == .vertical   ? 64  : 100
                )
                .frame(maxWidth: axis == .vertical ? .infinity : nil)
                .overlay(
                    Text(card.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                )
        }
        .onAnimationComplete { animationCompleted = true }
        .id(stackID)

        if axis == .horizontal {
            ScrollView(.horizontal, showsIndicators: false) {
                stack.padding(.horizontal)
            }
        } else {
            stack
        }
    }

    private var completionBadge: some View {
        Label("Animation complete", systemImage: "checkmark.circle.fill")
            .font(.subheadline.bold())
            .foregroundStyle(.green)
            .opacity(animationCompleted ? 1 : 0)
            .animation(.easeIn(duration: 0.2), value: animationCompleted)
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
                    replay()
                } label: {
                    Label("Replay", systemImage: "arrow.counterclockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!animationCompleted)
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

    private func replay() {
        animationCompleted = false
        stackID = UUID()
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
        switch self {
        case .topDown:  return TopDownEntrance(duration: duration, staggerDelay: staggerDelay)
        case .bottomUp: return BottomUpEntrance(duration: duration, staggerDelay: staggerDelay)
        case .leading:  return LeadingEntrance(duration: duration, staggerDelay: staggerDelay)
        case .trailing: return TrailingEntrance(duration: duration, staggerDelay: staggerDelay)
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

    func animationDuration(for index: Int, total: Int) -> Double {
        switch index % 3 {
        case 0: duration
        case 1: duration * 0.9
        default: duration * 1.1
        }
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        switch index % 3 {
        case 0: CGSize(width: 0, height: -amount)
        case 1: CGSize(width: 0, height: amount)
        default: CGSize(width: -amount, height: 0)
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

#Preview("Vertical") {
    NavigationStack {
        AnimatedStackExampleView(axis: .vertical)
    }
}

#Preview("Horizontal") {
    NavigationStack {
        AnimatedStackExampleView(axis: .horizontal)
    }
}

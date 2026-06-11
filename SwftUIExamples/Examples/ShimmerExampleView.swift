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
                ShimmerRectRow(label: "Blue",   color: .blue)
                ShimmerRectRow(label: "Purple", color: .purple)
                ShimmerRectRow(label: "Green",  color: .green)
                ShimmerRectRow(label: "Orange", color: .orange)
            }
            .padding()
        }
        .navigationTitle("Shimmer Effect")
    }
}

// MARK: - ShimmerRectRow

private struct ShimmerRectRow: View {

    // MARK: - Properties

    let label: String
    let color: Color

    @State private var isActive:      Bool   = true
    @State private var angle:         Double = 20
    @State private var duration:      Double = 1.0
    @State private var delay:         Double = 0.0
    @State private var width:         Double = 0.3
    @State private var shimmerColor:  Color  = .white

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            shimmerRect
            toggleButton
            angleSlider
            durationSlider
            delaySlider
            widthSlider
            colorPicker
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
    }

    // MARK: - Subviews

    private var shimmerRect: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(color)
            .frame(height: 90)
            .shimmering(isActive: isActive, duration: duration, delay: delay, angle: angle, width: width, color: shimmerColor)
    }

    private var toggleButton: some View {
        Button {
            isActive.toggle()
        } label: {
            Label(isActive ? "Stop" : "Play", systemImage: isActive ? "stop.fill" : "play.fill")
                .font(.caption.bold())
                .foregroundStyle(isActive ? .red : .green)
        }
        .buttonStyle(.bordered)
        .tint(isActive ? .red : .green)
    }

    private var angleSlider: some View {
        sliderRow(label: "\(label) — Angle: \(Int(angle))°",
                  value: $angle, range: -90...90, step: 1)
    }

    private var durationSlider: some View {
        sliderRow(label: "Duration: \(String(format: "%.1f", duration)) s",
                  value: $duration, range: 0.1...6.0, step: 0.1)
    }

    private var delaySlider: some View {
        sliderRow(label: "Delay: \(String(format: "%.1f", delay)) s",
                  value: $delay, range: 0.0...3.0, step: 0.1)
    }

    private var widthSlider: some View {
        sliderRow(label: "Band width: \(Int(width * 100))%",
                  value: $width, range: 0.0...1.0, step: 0.01)
    }

    private var colorPicker: some View {
        ColorPicker("Shimmer color", selection: $shimmerColor)
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private func sliderRow(label: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Slider(value: value, in: range, step: step)
                .tint(color)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ShimmerExampleView()
    }
}

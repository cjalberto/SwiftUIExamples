//
//  AnimatedVStack.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - AnimatedVStack

/// A vertical stack that reveals items top-to-bottom with a chained animation:
/// each item starts offset below its final position and slides up while fading in.
/// The next item begins its animation only after the previous one finishes.
struct AnimatedVStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {

    // MARK: - Properties

    let data: Data
    let spacing: CGFloat
    let duration: Double
    let staggerDelay: Double
    let slideOffset: CGFloat
    @ViewBuilder let content: (Data.Element) -> Content

    @State private var visibleIDs: Set<Data.Element.ID> = []

    // MARK: - Init

    init(
        _ data: Data,
        spacing: CGFloat = 8,
        duration: Double = 0.45,
        staggerDelay: Double = 0.45,
        slideOffset: CGFloat = 36,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.spacing = spacing
        self.duration = duration
        self.staggerDelay = staggerDelay
        self.slideOffset = slideOffset
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        let items = Array(data)
        VStack(spacing: spacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                content(item)
                    .opacity(visibleIDs.contains(item.id) ? 1 : 0)
                    .offset(y: visibleIDs.contains(item.id) ? 0 : slideOffset)
                    .animation(
                        .easeOut(duration: duration)
                        .delay(delay(for: index, total: items.count)),
                        value: visibleIDs
                    )
            }
        }
        .onAppear { animate(items: items) }
    }

    // MARK: - Helpers

    /// Item 0 starts immediately; each subsequent item waits for the previous to finish.
    /// With staggerDelay == duration (default) the chain is tight: item N+1 starts exactly
    /// when item N arrives. Reduce staggerDelay for overlap; increase for a pause between items.
    private func delay(for index: Int, total: Int) -> Double {
        Double(index) * staggerDelay
    }

    private func animate(items: [Data.Element]) {
        visibleIDs.removeAll()
        for item in items {
            visibleIDs.insert(item.id)
        }
    }
}

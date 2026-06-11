//
//  AnimatedStack.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - AnimatedStack

struct AnimatedStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {

    // MARK: - Properties

    let data: Data
    let axis: Axis
    let entrance: any StackEntrance
    let spacing: CGFloat
    let slideOffset: CGFloat
    var onComplete: (() -> Void)?
    @ViewBuilder let content: (Data.Element) -> Content

    @State private var visibleIDs: Set<Data.Element.ID> = []
    @State private var completionTask: Task<Void, Never>?

    // MARK: - Init

    init(
        _ data: Data,
        axis: Axis = .vertical,
        entrance: any StackEntrance = TopDownEntrance(),
        spacing: CGFloat = 8,
        slideOffset: CGFloat = 36,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.axis = axis
        self.entrance = entrance
        self.spacing = spacing
        self.slideOffset = slideOffset
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        let items = Array(data)
        Group {
            if axis == .vertical {
                VStack(spacing: spacing) { itemViews(items: items) }
            } else {
                HStack(spacing: spacing) { itemViews(items: items) }
            }
        }
        .onAppear {
            guard visibleIDs.isEmpty else { return }
            animate(items: items)
        }
        .onDisappear { completionTask?.cancel() }
    }

    // MARK: - Modifier

    func onAnimationComplete(_ action: @escaping () -> Void) -> Self {
        var copy = self
        copy.onComplete = action
        return copy
    }

    // MARK: - Helpers

    @ViewBuilder
    private func itemViews(items: [Data.Element]) -> some View {
        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            let isVisible = visibleIDs.contains(item.id)
            content(item)
                .opacity(isVisible ? 1 : 0)
                .offset(isVisible ? .zero : entrance.initialOffset(for: index, total: items.count, amount: slideOffset))
                .animation(
                    entrance.animation(for: index, total: items.count)
                        .delay(entrance.itemDelay(for: index, total: items.count, axis: axis)),
                    value: visibleIDs
                )
        }
    }

    private func animate(items: [Data.Element]) {
        completionTask?.cancel()
        visibleIDs.removeAll()
        for item in items { visibleIDs.insert(item.id) }

        guard let onComplete, !items.isEmpty else { return }

        let totalDuration = items.indices
            .map {
                entrance.itemDelay(for: $0, total: items.count, axis: axis) +
                entrance.animationDuration(for: $0, total: items.count)
            }
            .max() ?? 0

        completionTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(totalDuration))
            guard !Task.isCancelled else { return }
            onComplete()
        }
    }
}

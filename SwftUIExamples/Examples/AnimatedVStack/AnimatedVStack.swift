//
//  AnimatedVStack.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - AnimatedVStack

struct AnimatedVStack<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {

    // MARK: - Properties

    let data: Data
    let entrance: any StackEntrance
    let spacing: CGFloat
    let slideOffset: CGFloat
    @ViewBuilder let content: (Data.Element) -> Content

    @State private var visibleIDs: Set<Data.Element.ID> = []

    // MARK: - Init

    init(
        _ data: Data,
        entrance: any StackEntrance = TopDownEntrance(),
        spacing: CGFloat = 8,
        slideOffset: CGFloat = 36,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.entrance = entrance
        self.spacing = spacing
        self.slideOffset = slideOffset
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        let items = Array(data)
        VStack(spacing: spacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let isVisible = visibleIDs.contains(item.id)
                content(item)
                    .opacity(isVisible ? 1 : 0)
                    .offset(isVisible ? .zero : entrance.initialOffset(for: index, total: items.count, amount: slideOffset))
                    .animation(
                        entrance.animation(for: index, total: items.count)
                            .delay(entrance.itemDelay(for: index, total: items.count)),
                        value: visibleIDs
                    )
            }
        }
        .onAppear { animate(items: items) }
    }

    // MARK: - Helpers

    private func animate(items: [Data.Element]) {
        visibleIDs.removeAll()
        for item in items {
            visibleIDs.insert(item.id)
        }
    }
}

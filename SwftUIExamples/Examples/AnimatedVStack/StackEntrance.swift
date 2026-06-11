//
//  StackEntrance.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - Protocol

protocol StackEntrance {
    var staggerDelay: Double { get }
    /// Animation curve for item at `index`. Return the same value for all indices
    /// to use a uniform curve, or vary it per-item for fully custom behavior.
    func animation(for index: Int, total: Int) -> Animation
    /// Starting offset for item at `index`. Use the X axis for horizontal slides,
    /// Y axis for vertical, or combine both for diagonal entrances.
    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize
    func itemDelay(for index: Int, total: Int) -> Double
}

extension StackEntrance {
    func itemDelay(for index: Int, total: Int) -> Double {
        Double(index) * staggerDelay
    }
}

// MARK: - TopDownEntrance

struct TopDownEntrance: StackEntrance {
    var animation: Animation
    var staggerDelay: Double

    init(animation: Animation = .easeOut(duration: 0.45), staggerDelay: Double = 0.45) {
        self.animation = animation
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation { animation }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: 0, height: amount)
    }
}

// MARK: - BottomUpEntrance

struct BottomUpEntrance: StackEntrance {
    var animation: Animation
    var staggerDelay: Double

    init(animation: Animation = .easeOut(duration: 0.45), staggerDelay: Double = 0.45) {
        self.animation = animation
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation { animation }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: 0, height: amount)
    }

    func itemDelay(for index: Int, total: Int) -> Double {
        Double(total - 1 - index) * staggerDelay
    }
}

// MARK: - LeadingEntrance

struct LeadingEntrance: StackEntrance {
    var animation: Animation
    var staggerDelay: Double

    init(animation: Animation = .easeOut(duration: 0.45), staggerDelay: Double = 0.45) {
        self.animation = animation
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation { animation }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: -amount, height: 0)
    }
}

// MARK: - TrailingEntrance

struct TrailingEntrance: StackEntrance {
    var animation: Animation
    var staggerDelay: Double

    init(animation: Animation = .easeOut(duration: 0.45), staggerDelay: Double = 0.45) {
        self.animation = animation
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation { animation }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: amount, height: 0)
    }
}

// MARK: - Convenience

extension StackEntrance where Self == TopDownEntrance {
    static var topDown: TopDownEntrance { TopDownEntrance() }
    static func topDown(animation: Animation, staggerDelay: Double = 0.45) -> TopDownEntrance {
        TopDownEntrance(animation: animation, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == BottomUpEntrance {
    static var bottomUp: BottomUpEntrance { BottomUpEntrance() }
    static func bottomUp(animation: Animation, staggerDelay: Double = 0.45) -> BottomUpEntrance {
        BottomUpEntrance(animation: animation, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == LeadingEntrance {
    static var leading: LeadingEntrance { LeadingEntrance() }
    static func leading(animation: Animation, staggerDelay: Double = 0.45) -> LeadingEntrance {
        LeadingEntrance(animation: animation, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == TrailingEntrance {
    static var trailing: TrailingEntrance { TrailingEntrance() }
    static func trailing(animation: Animation, staggerDelay: Double = 0.45) -> TrailingEntrance {
        TrailingEntrance(animation: animation, staggerDelay: staggerDelay)
    }
}

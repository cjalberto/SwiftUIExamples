//
//  StackEntrance.swift
//  SwiftUIExamplesComponents
//
//  Created by Carlos Jaramillo on 10/6/26.
//

import SwiftUI

// MARK: - Protocol

protocol StackEntrance {
    var animationDuration: Double { get }
    var staggerDelay: Double { get }
    /// Animation curve for item at `index`. Return the same value for all indices
    /// to use a uniform curve, or vary it per-item for fully custom behavior.
    func animation(for index: Int, total: Int) -> Animation
    /// Starting offset for item at `index`. Use the X axis for horizontal slides,
    /// Y axis for vertical, or combine both for diagonal entrances.
    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize
    /// Delay before item at `index` starts animating. Receives `axis` so entrances
    /// can adapt their reveal order depending on layout direction.
    func itemDelay(for index: Int, total: Int, axis: Axis) -> Double
}

extension StackEntrance {
    func itemDelay(for index: Int, total: Int, axis: Axis) -> Double {
        Double(index) * staggerDelay
    }
}

// MARK: - TopDownEntrance

struct TopDownEntrance: StackEntrance {
    var animationDuration: Double
    var staggerDelay: Double

    init(duration: Double = 0.45, staggerDelay: Double = 0.45) {
        self.animationDuration = duration
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation {
        .easeOut(duration: animationDuration)
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: 0, height: amount)
    }
}

// MARK: - BottomUpEntrance

struct BottomUpEntrance: StackEntrance {
    var animationDuration: Double
    var staggerDelay: Double

    init(duration: Double = 0.45, staggerDelay: Double = 0.45) {
        self.animationDuration = duration
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation {
        .easeOut(duration: animationDuration)
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: 0, height: amount)
    }

    func itemDelay(for index: Int, total: Int, axis: Axis) -> Double {
        switch axis {
        case .vertical:   return Double(total - 1 - index) * staggerDelay
        case .horizontal: return Double(index) * staggerDelay
        @unknown default: return Double(index) * staggerDelay
        }
    }
}

// MARK: - LeadingEntrance

struct LeadingEntrance: StackEntrance {
    var animationDuration: Double
    var staggerDelay: Double

    init(duration: Double = 0.45, staggerDelay: Double = 0.45) {
        self.animationDuration = duration
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation {
        .easeOut(duration: animationDuration)
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: -amount, height: 0)
    }
}

// MARK: - TrailingEntrance

struct TrailingEntrance: StackEntrance {
    var animationDuration: Double
    var staggerDelay: Double

    init(duration: Double = 0.45, staggerDelay: Double = 0.45) {
        self.animationDuration = duration
        self.staggerDelay = staggerDelay
    }

    func animation(for index: Int, total: Int) -> Animation {
        .easeOut(duration: animationDuration)
    }

    func initialOffset(for index: Int, total: Int, amount: CGFloat) -> CGSize {
        CGSize(width: amount, height: 0)
    }
}

// MARK: - Convenience

extension StackEntrance where Self == TopDownEntrance {
    static var topDown: TopDownEntrance { TopDownEntrance() }
    static func topDown(duration: Double, staggerDelay: Double = 0.45) -> TopDownEntrance {
        TopDownEntrance(duration: duration, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == BottomUpEntrance {
    static var bottomUp: BottomUpEntrance { BottomUpEntrance() }
    static func bottomUp(duration: Double, staggerDelay: Double = 0.45) -> BottomUpEntrance {
        BottomUpEntrance(duration: duration, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == LeadingEntrance {
    static var leading: LeadingEntrance { LeadingEntrance() }
    static func leading(duration: Double, staggerDelay: Double = 0.45) -> LeadingEntrance {
        LeadingEntrance(duration: duration, staggerDelay: staggerDelay)
    }
}

extension StackEntrance where Self == TrailingEntrance {
    static var trailing: TrailingEntrance { TrailingEntrance() }
    static func trailing(duration: Double, staggerDelay: Double = 0.45) -> TrailingEntrance {
        TrailingEntrance(duration: duration, staggerDelay: staggerDelay)
    }
}

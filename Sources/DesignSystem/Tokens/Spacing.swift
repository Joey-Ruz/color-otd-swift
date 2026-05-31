import CoreGraphics
import SwiftUI

/// 4-point base scale per Style Guide.
enum Spacing {
    static let s2: CGFloat = 2
    static let s4: CGFloat = 4
    static let s6: CGFloat = 6
    static let s8: CGFloat = 8
    static let s9: CGFloat = 9
    static let s10: CGFloat = 10
    static let s11: CGFloat = 11
    static let s12: CGFloat = 12
    static let s14: CGFloat = 14
    static let s16: CGFloat = 16
    static let s18: CGFloat = 18
    static let s22: CGFloat = 22
    static let s24: CGFloat = 24
    /// Standard screen edge gutter.
    static let gutter: CGFloat = 26
    static let s30: CGFloat = 30
    static let s32: CGFloat = 32
    static let s34: CGFloat = 34
    static let s44: CGFloat = 44
    static let s48: CGFloat = 48
    static let s64: CGFloat = 64
    static let s70: CGFloat = 70
    static let s130: CGFloat = 130

    /// Hero color field height on Today / ColorDetail.
    static let heroHeight: CGFloat = 588
}

/// Radii per Style Guide.
enum CornerRadius {
    /// Color tiles, recipe bar.
    static let tile: CGFloat = 4
    /// Cards, sheets-as-cards.
    static let card: CGFloat = 16
    /// Sheet corners, big modals.
    static let sheet: CGFloat = 26
    /// Pills, segmented chips.
    static let chip: CGFloat = 9
    /// Search bar, settings row corners.
    static let inputField: CGFloat = 12
    /// Circle (pill at infinity).
    static let pill: CGFloat = 999
}

/// Minimum hit target per Style Guide (≥ 44 × 44).
enum HitTarget {
    static let minimum: CGFloat = 44
}

import Foundation
import SwiftUI

/// String-typed wrapper for a color's stable identifier (e.g. "prussian-blue").
/// Swift's nearest analogue to Dart's extension types.
struct ColorId: Hashable, RawRepresentable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    let rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }
    init(_ raw: String) { self.rawValue = raw }
    init(stringLiteral value: String) { self.rawValue = value }
    var description: String { rawValue }
}

/// A single Color of the Day — the central domain entity.
///
/// Per design: `id`, `name`, `hex`, `onColor` and `date` are always present.
/// `poem`, `recipe`, and `lenses` may be absent when summarized in lists (e.g. Archive).
struct ColorEntity: Hashable, Identifiable {
    let id: ColorId
    let name: String
    /// 6-digit hex, with leading `#`.
    let hex: String
    /// A tinted off-white or near-black chosen for contrast with the hex color.
    /// Stored, not derived — hand-curated per color for readability.
    let onColorHex: String
    /// Long-form date string, e.g. "Thursday, 28 May 2026".
    let date: String
    /// Short-form date string, e.g. "May 28".
    let dateShort: String

    /// One-line italic poem rendered under the values on the hero.
    let poem: String?
    /// Optional "how to make this colour" recipe.
    let recipe: RecipeEntity?
    /// Optional fully-loaded lens content. Absent in list views; present in detail.
    let lenses: [LensEntity]?

    // MARK: Derived

    /// SwiftUI Color for the day-colour itself.
    var color: Color { Color(hexString: hex) ?? .gray }
    /// SwiftUI Color for any text / control rendered over the day-colour.
    var onColor: Color { Color(hexString: onColorHex) ?? .white }

    /// 0–255 RGB triple derived from hex.
    var rgb: (r: Int, g: Int, b: Int) {
        guard let v = UInt32(hex.dropFirst(), radix: 16) else { return (0, 0, 0) }
        return (Int((v >> 16) & 0xFF), Int((v >> 8) & 0xFF), Int(v & 0xFF))
    }

    /// 0–360 hue, 0–100 sat, 0–100 light derived from hex.
    var hsl: (h: Int, s: Int, l: Int) {
        let (ri, gi, bi) = rgb
        let r = Double(ri) / 255, g = Double(gi) / 255, b = Double(bi) / 255
        let maxC = max(r, g, b), minC = min(r, g, b)
        let l = (maxC + minC) / 2
        guard maxC != minC else { return (0, 0, Int(round(l * 100))) }
        let d = maxC - minC
        let s = l > 0.5 ? d / (2 - maxC - minC) : d / (maxC + minC)
        var h: Double
        switch maxC {
        case r: h = (g - b) / d + (g < b ? 6 : 0)
        case g: h = (b - r) / d + 2
        default: h = (r - g) / d + 4
        }
        h /= 6
        return (Int(round(h * 360)), Int(round(s * 100)), Int(round(l * 100)))
    }

    /// Look up a lens by id from `lenses`. Returns `nil` if lenses aren't loaded.
    func lens(_ id: LensId) -> LensEntity? {
        lenses?.first { $0.id == id }
    }
}

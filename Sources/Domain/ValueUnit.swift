import Foundation

/// How colour values are rendered in the UI — user preference, persisted.
enum ValueUnit: String, Codable, CaseIterable, Identifiable {
    case hex = "HEX"
    case rgb = "RGB"
    case hsl = "HSL"

    var id: String { rawValue }

    /// Format a colour's values for display in the unit's preferred shape.
    func format(_ color: ColorEntity) -> String {
        switch self {
        case .hex:
            return color.hex.uppercased()
        case .rgb:
            let (r, g, b) = color.rgb
            return "\(r) \(g) \(b)"
        case .hsl:
            let (h, s, l) = color.hsl
            return "\(h) \(s) \(l)"
        }
    }
}

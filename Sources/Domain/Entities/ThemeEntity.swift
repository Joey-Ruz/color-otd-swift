import Foundation

/// String-typed identifier for a curated theme on Search.
struct ThemeId: Hashable, RawRepresentable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    let rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }
    init(_ raw: String) { self.rawValue = raw }
    init(stringLiteral value: String) { self.rawValue = value }
    var description: String { rawValue }
}

/// A curated grouping of colors, e.g. "Colours of mourning".
struct ThemeEntity: Hashable, Identifiable {
    let id: ThemeId
    let label: String
    /// Colour ids that belong to this theme, in display order.
    let colorIds: [ColorId]
}

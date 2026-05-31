import Foundation

/// String-typed wrapper for a lens identifier (e.g. "art", "fashion").
struct LensId: Hashable, RawRepresentable, Codable, ExpressibleByStringLiteral, CustomStringConvertible {
    let rawValue: String
    init(rawValue: String) { self.rawValue = rawValue }
    init(_ raw: String) { self.rawValue = raw }
    init(stringLiteral value: String) { self.rawValue = value }
    var description: String { rawValue }

    static let art       = LensId("art")
    static let fashion   = LensId("fashion")
    static let nature    = LensId("nature")
    static let pop       = LensId("pop")
    static let etymology = LensId("etymology")
    static let symbolism = LensId("symbolism")

    /// Order in which lenses are rendered on Today / ColorDetail.
    static let displayOrder: [LensId] = [.art, .fashion, .nature, .pop, .etymology, .symbolism]
}

/// One of six lenses through which the day's colour is explored.
struct LensEntity: Hashable, Identifiable {
    let id: LensId
    /// Display label, e.g. "Art History".
    let label: String
    /// Glyph kind, mapped to a LensGlyph in the design system.
    let glyph: LensKind
    /// Italic intro paragraph rendered on the masthead.
    let intro: String
    /// 3 curated entries, in display order.
    let entries: [LensEntryEntity]
}

extension LensId {
    /// Display label for a known lens id.
    var defaultLabel: String {
        switch self {
        case .art: "Art History"
        case .fashion: "Fashion"
        case .nature: "Nature"
        case .pop: "Pop Culture"
        case .etymology: "Etymology"
        case .symbolism: "Symbolism"
        default: rawValue.capitalized
        }
    }

    /// Default glyph for a known lens id.
    var defaultGlyph: LensKind {
        switch self {
        case .art: .brush
        case .fashion: .thread
        case .nature: .leaf
        case .pop: .star
        case .etymology: .quote
        case .symbolism: .eye
        default: .star
        }
    }
}

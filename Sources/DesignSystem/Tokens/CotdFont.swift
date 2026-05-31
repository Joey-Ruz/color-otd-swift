import SwiftUI

/// Three voices of type per Style Guide:
/// • Newsreader (serif) — display, titles, body, italic poems
/// • Archivo (sans) — labels, metadata, UI chrome
/// • Space Mono — color values (hex / rgb / hsl)
enum CotdFont {
    // MARK: - Families (registered via UIAppFonts)
    static let serif = "Newsreader"
    static let serifItalic = "Newsreader-Italic"
    static let sans = "Archivo"
    static let mono = "SpaceMono-Regular"
    static let monoBold = "SpaceMono-Bold"

    // MARK: - Serif type scale
    /// 64 / 1.0 / -0.025 tracking — h1 hero
    static let displayLarge = Font.custom(serif, size: 64).weight(.regular)
    /// 54 / 1.0 / -0.015 — color hero name
    static let displayMedium = Font.custom(serif, size: 54).weight(.regular)
    /// 44 / -0.02 — screen titles (Archive, Profile, Search)
    static let displaySmall = Font.custom(serif, size: 44).weight(.regular)
    /// 34 / -0.015 — section titles
    static let titleLarge = Font.custom(serif, size: 34).weight(.regular)
    /// 28 — entry titles in CategoryDetail
    static let titleMedium = Font.custom(serif, size: 28).weight(.regular)
    /// 27 / -0.01 — "Six ways to see X" sub-display
    static let titleSmall = Font.custom(serif, size: 27).weight(.regular)
    /// 24 — secondary headlines (principles)
    static let headline = Font.custom(serif, size: 24).weight(.regular)
    /// 22 — lens index row label
    static let lensRowTitle = Font.custom(serif, size: 22).weight(.regular)
    /// 21 — recipe note, theme label
    static let recipeNote = Font.custom(serif, size: 21).weight(.regular)
    /// 19 — masthead pill below display
    static let serifBody = Font.custom(serif, size: 19).weight(.regular)
    /// 17 — swatch tile name
    static let swatchName = Font.custom(serif, size: 17).weight(.regular)
    /// 16.5 / 1.55 line height — body prose
    static let body = Font.custom(serif, size: 16.5).weight(.regular)
    /// 18.5 italic — poem
    static let poem = Font.custom(serifItalic, size: 18.5).weight(.regular)
    /// 18 italic — lens intro
    static let lensIntro = Font.custom(serifItalic, size: 17).weight(.regular)
    /// 15 italic — small italic flourish
    static let italicSmall = Font.custom(serifItalic, size: 15).weight(.regular)

    // MARK: - Sans type scale
    /// 11 / 0.18em tracking / uppercase / weight 600 — museum-placard SectionLabel
    static let label = Font.custom(sans, size: 11).weight(.semibold)
    /// 13.5 — color metadata under hero
    static let metadata = Font.custom(sans, size: 13.5)
    /// 15 — settings row label
    static let settingRow = Font.custom(sans, size: 15)
    /// 13 — search input
    static let input = Font.custom(sans, size: 15)
    /// 12.5 — lens row teaser, small captions
    static let caption = Font.custom(sans, size: 12.5)
    /// 12 — secondary caption
    static let captionSmall = Font.custom(sans, size: 12)
    /// 11 / 0.18em / uppercase / weight 600 — masthead label over color
    static let mastheadLabel = Font.custom(sans, size: 11).weight(.semibold)
    /// 10 — tab bar label
    static let tabLabel = Font.custom(sans, size: 10).weight(.semibold)
    /// 9.5 / 0.20em / uppercase / weight 600 — value placard label (HEX / RGB / HSL)
    static let valuePlacardLabel = Font.custom(sans, size: 9.5).weight(.semibold)

    // MARK: - Mono type scale
    /// 15 — color values on hero
    static let monoValue = Font.custom(mono, size: 14)
    /// 13 — segmented control text (HEX/RGB/HSL chip)
    static let monoChip = Font.custom(mono, size: 13)
    /// 12 — spacing scale labels, version
    static let monoSmall = Font.custom(mono, size: 12)
    /// 11 — lens row index, metadata pill
    static let monoIndex = Font.custom(mono, size: 11)
    /// 10.5 — swatch hex caption
    static let monoSwatch = Font.custom(mono, size: 10.5)
    /// 10 — placeholder label inside StripePlaceholder
    static let monoMicro = Font.custom(mono, size: 10)
}

// MARK: - SwiftUI helpers
extension View {
    /// Apply a letter-spacing as tracking points proportional to font size.
    /// Matches CSS `letter-spacing: 0.18em` style values from the design.
    func tracking(em: Double, fontSize: Double) -> some View {
        self.tracking(em * fontSize)
    }
}

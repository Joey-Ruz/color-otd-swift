import Foundation

/// Codable schema for the bundled per-colour content JSON files at
/// `Sources/Resources/lens_content/{colorId}.json`. These are the
/// authoritative source of editorial content — both the local app
/// and (later) the admin import script read the same files.
struct ColorContentJSON: Codable {
    let id: String
    let name: String
    let hex: String
    let onColor: String
    let date: String
    let dateShort: String
    let poem: String?
    let recipe: RecipeJSON?
    let lenses: [LensJSON]
}

struct RecipeJSON: Codable {
    let note: String
    let mix: [MixJSON]
}

struct MixJSON: Codable {
    let name: String
    let hex: String
    let parts: Int
}

struct LensJSON: Codable {
    let id: String         // "art", "fashion", "nature", "pop", "etymology", "symbolism"
    let label: String
    let glyph: String      // matches LensKind raw value
    let intro: String
    let entries: [EntryJSON]
}

struct EntryJSON: Codable {
    let title: String
    let meta: String
    let blurb: String
    let imageRef: String
    let imageUrl: String?
    let imageCredit: String?
    let imageSourceUrl: String?
}

// MARK: - Entity conversion

extension ColorContentJSON {
    /// Build a fully hydrated ColorEntity (with lens + recipe content).
    func toEntity() -> ColorEntity {
        ColorEntity(
            id: ColorId(id),
            name: name,
            hex: hex,
            onColorHex: onColor,
            date: date,
            dateShort: dateShort,
            poem: poem,
            recipe: recipe?.toEntity(),
            lenses: lenses.map { $0.toEntity() }
        )
    }

    /// Summary entity without lens / recipe content (for grid views).
    func toSummary() -> ColorEntity {
        ColorEntity(
            id: ColorId(id),
            name: name,
            hex: hex,
            onColorHex: onColor,
            date: date,
            dateShort: dateShort,
            poem: nil,
            recipe: nil,
            lenses: nil
        )
    }
}

extension RecipeJSON {
    func toEntity() -> RecipeEntity {
        RecipeEntity(
            note: note,
            mix: mix.map { RecipeMixEntity(name: $0.name, hex: $0.hex, parts: $0.parts) }
        )
    }
}

extension LensJSON {
    func toEntity() -> LensEntity {
        let lensId = LensId(id)
        let glyphKind = LensKind(rawValue: glyph) ?? lensId.defaultGlyph
        return LensEntity(
            id: lensId,
            label: label,
            glyph: glyphKind,
            intro: intro,
            entries: entries.enumerated().map { idx, e in
                LensEntryEntity(
                    lensId: lensId,
                    index: idx,
                    meta: e.meta,
                    title: e.title,
                    blurb: e.blurb,
                    imageRef: e.imageRef,
                    imageUrl: e.imageUrl,
                    imageCredit: e.imageCredit,
                    imageSourceUrl: e.imageSourceUrl
                )
            }
        )
    }
}

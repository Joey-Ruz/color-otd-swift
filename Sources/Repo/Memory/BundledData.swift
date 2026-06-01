import Foundation

/// Loads colour content from `Sources/Resources/lens_content/{colorId}.json`
/// at startup, caches the parsed catalogue, and exposes lookup helpers.
///
/// Source of truth for editorial content is the JSON files in the repo.
/// The future Cloud Functions admin import (Phase 14) reads the same files.
enum BundledData {

    // MARK: - Archive ordering

    /// Canonical display order (most recent first) for the Archive tab.
    /// Add new colour ids here as JSON files are added to the bundle.
    static let archiveOrder: [ColorId] = [
        "prussian-blue",
        "vermilion",
        "tyrian-purple",
        "orpiment",
        "ultramarine",
        "verdigris",
        "mummy-brown",
        "scheeles-green",
        "carmine",
        "indian-yellow",
        "malachite",
        "han-purple",
        "lead-white",
        "payne-grey",
        "saffron",
        "cobalt",
    ]

    /// Pre-seeded favourites so Profile has content on first launch.
    static let defaultFavorites: Set<ColorId> = [
        "prussian-blue", "tyrian-purple", "verdigris", "carmine", "ultramarine",
    ]

    /// Curated browse themes — these reference colour ids, not full entities,
    /// so they stay in code rather than per-colour JSON.
    static let themes: [ThemeEntity] = [
        ThemeEntity(
            id: "mourning",
            label: "Colours of mourning",
            colorIds: ["payne-grey", "tyrian-purple", "mummy-brown"]
        ),
        ThemeEntity(
            id: "poison",
            label: "Pigments that could kill",
            colorIds: ["scheeles-green", "vermilion", "orpiment", "lead-white"]
        ),
        ThemeEntity(
            id: "royal",
            label: "Reserved for royalty",
            colorIds: ["tyrian-purple", "ultramarine", "han-purple"]
        ),
    ]

    // MARK: - Cached parsed content

    /// All fully-hydrated colours loaded from JSON, in archive order.
    /// Missing JSON files are skipped (so we can grow the catalogue incrementally).
    static let allColors: [ColorEntity] = archiveOrder.compactMap(loadColor)

    /// Index by id for O(1) lookups.
    private static let colorIndex: [ColorId: ColorEntity] = {
        var dict: [ColorId: ColorEntity] = [:]
        for color in allColors { dict[color.id] = color }
        return dict
    }()

    // MARK: - Public API

    /// Full colour with lens + recipe content. nil if JSON missing.
    static func fullColor(id: ColorId) -> ColorEntity? {
        colorIndex[id]
    }

    /// Lightweight summary (no lens or recipe). Used by grid views.
    static func summaryColor(id: ColorId) -> ColorEntity? {
        guard let c = colorIndex[id] else { return nil }
        return ColorEntity(
            id: c.id,
            name: c.name,
            hex: c.hex,
            onColorHex: c.onColorHex,
            date: c.date,
            dateShort: c.dateShort,
            poem: nil,
            recipe: nil,
            lenses: nil
        )
    }

    /// Compatibility shim — older code expected a tuple list of summaries.
    /// Returns the same row shape as the previous hand-written archive.
    static var archiveSummaries: [(id: ColorId, name: String, hex: String, date: String, dateShort: String, onColor: String)] {
        allColors.map { c in
            (id: c.id, name: c.name, hex: c.hex, date: c.date, dateShort: c.dateShort, onColor: c.onColorHex)
        }
    }

    // MARK: - JSON loading

    private static func loadColor(id: ColorId) -> ColorEntity? {
        guard let url = Bundle.main.url(forResource: id.rawValue, withExtension: "json") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONDecoder().decode(ColorContentJSON.self, from: data)
            return json.toEntity()
        } catch {
            print("BundledData: failed to load \(id.rawValue).json — \(error)")
            return nil
        }
    }

    /// Generate placeholder lens content for a colour without curated lenses.
    /// Used by ColorDetail/CategoryDetail when an entity arrives without lenses.
    static func placeholderLenses(for color: ColorEntity) -> [LensEntity] {
        LensId.displayOrder.map { lensId in
            LensEntity(
                id: lensId,
                label: lensId.defaultLabel,
                glyph: lensId.defaultGlyph,
                intro: "Editorial intro for \(lensId.defaultLabel.lowercased()) is curated per colour during the build.",
                entries: (0..<3).map { i in
                    LensEntryEntity(
                        lensId: lensId,
                        index: i,
                        meta: "Artist / source · year",
                        title: ["First entry", "Second entry", "Third entry"][i],
                        blurb: "Each lens shows three to five curated entries with image, caption and a short essay. The layout stays editorial, never a bare list.",
                        imageRef: "\(lensId.defaultLabel) reference"
                    )
                }
            )
        }
    }
}

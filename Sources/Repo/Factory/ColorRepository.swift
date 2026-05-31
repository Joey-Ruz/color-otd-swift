import Foundation

/// Manager-equivalent contract for fetching colour content.
///
/// Per Flutter rules: this protocol does not import any Firebase types so that
/// `MemoryColorRepository` can implement it cleanly.
protocol ColorRepository: Sendable {
    /// Today's colour with full lens + recipe content.
    func todayColor() async -> CotdResult<ColorEntity>

    /// A specific colour by id, with full lens + recipe content.
    func color(byId id: ColorId) async -> CotdResult<ColorEntity>

    /// All past colours, summaries only (no lens content). Used by Archive grid.
    func archive() async -> CotdResult<[ColorEntity]>

    /// Free-text search across colour name + hex over the catalog.
    func search(_ query: String) async -> CotdResult<[ColorEntity]>

    /// Curated themes for the Search browse state.
    func themes() async -> CotdResult<[ThemeEntity]>
}

import Foundation

/// Manager-equivalent contract for the user's saved-colour palette.
/// Mutates CotdAppState.favorites — views observe that property directly.
@MainActor
protocol FavoritesService {
    /// Load favorites at app launch / sign-in.
    func load() async -> CotdResult<Void>

    /// Toggle a colour in or out of the saved palette.
    func toggle(_ id: ColorId) async -> CotdResult<Void>
}

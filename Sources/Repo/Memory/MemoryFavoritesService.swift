import Foundation

/// In-memory FavoritesService backed by `CotdAppState.favorites`.
/// Seeds from `BundledData.defaultFavorites` on load.
@MainActor
struct MemoryFavoritesService: FavoritesService {
    let state: CotdAppState

    init(state: CotdAppState = .instance) {
        self.state = state
    }

    func load() async -> CotdResult<Void> {
        state.favorites = BundledData.defaultFavorites
        return .success(())
    }

    func toggle(_ id: ColorId) async -> CotdResult<Void> {
        if state.favorites.contains(id) {
            state.favorites.remove(id)
        } else {
            state.favorites.insert(id)
        }
        return .success(())
    }
}

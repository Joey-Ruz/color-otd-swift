import SwiftUI

extension Today {
    /// Factory — the only public way to build a Today.Scene in production.
    /// Defaults inject Memory repositories so previews + early screens work
    /// without backend setup. Real Repositories swap in via Phase 15.
    enum Assembly {
        @MainActor
        static func build(
            colorRepo: ColorRepository = MemoryColorRepository(),
            favoritesService: FavoritesService = MemoryFavoritesService(),
            router: Router? = nil
        ) -> Today.Scene {
            let useCase = Today.UseCase(
                colorRepo: colorRepo,
                favoritesService: favoritesService
            )
            let presenter = Today.Presenter(useCase: useCase, router: router)
            return Today.Scene(presenter: presenter)
        }
    }
}

#Preview {
    Today.Assembly.build()
}

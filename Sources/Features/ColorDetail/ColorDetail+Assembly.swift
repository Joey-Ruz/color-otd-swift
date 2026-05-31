import SwiftUI

extension ColorDetail {
    enum Assembly {
        @MainActor
        static func build(
            seed: ColorEntity,
            colorRepo: ColorRepository = MemoryColorRepository(),
            favoritesService: FavoritesService = MemoryFavoritesService(),
            router: Router? = nil
        ) -> ColorDetail.Scene {
            let useCase = ColorDetail.UseCase(
                seed: seed,
                colorRepo: colorRepo,
                favoritesService: favoritesService
            )
            let presenter = ColorDetail.Presenter(useCase: useCase, router: router)
            return ColorDetail.Scene(presenter: presenter)
        }
    }
}

#Preview {
    NavigationStack {
        ColorDetail.Assembly.build(
            seed: BundledData.summaryColor(id: "vermilion")!
        )
    }
}

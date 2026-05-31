import SwiftUI

extension CategoryDetail {
    enum Assembly {
        @MainActor
        static func build(
            color: ColorEntity,
            lensId: LensId,
            colorRepo: ColorRepository = MemoryColorRepository(),
            favoritesService: FavoritesService = MemoryFavoritesService(),
            router: Router? = nil
        ) -> CategoryDetail.Scene {
            let useCase = CategoryDetail.UseCase(
                color: color,
                lensId: lensId,
                colorRepo: colorRepo,
                favoritesService: favoritesService
            )
            let presenter = CategoryDetail.Presenter(useCase: useCase, router: router)
            return CategoryDetail.Scene(presenter: presenter)
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetail.Assembly.build(
            color: BundledData.fullColor(id: "prussian-blue")!,
            lensId: .art
        )
    }
}

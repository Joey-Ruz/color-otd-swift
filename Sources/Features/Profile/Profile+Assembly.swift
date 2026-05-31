import SwiftUI

extension Profile {
    enum Assembly {
        @MainActor
        static func build(
            colorRepo: ColorRepository = MemoryColorRepository(),
            favoritesService: FavoritesService = MemoryFavoritesService(),
            settingsService: SettingsService = MemorySettingsService(),
            router: Router? = nil
        ) -> Profile.Scene {
            let useCase = Profile.UseCase(
                colorRepo: colorRepo,
                favoritesService: favoritesService,
                settingsService: settingsService
            )
            let presenter = Profile.Presenter(useCase: useCase, router: router)
            return Profile.Scene(presenter: presenter)
        }
    }
}

#Preview {
    Profile.Assembly.build()
}

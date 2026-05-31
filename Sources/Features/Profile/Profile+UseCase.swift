import Foundation
import Observation

extension Profile {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private let favoritesService: FavoritesService
        private let settingsService: SettingsService
        private let state: CotdAppState
        private var allColors: [ColorEntity] = []

        private(set) var output: UseCaseOutput = .loading

        init(
            colorRepo: ColorRepository,
            favoritesService: FavoritesService,
            settingsService: SettingsService,
            state: CotdAppState = .instance
        ) {
            self.colorRepo = colorRepo
            self.favoritesService = favoritesService
            self.settingsService = settingsService
            self.state = state
        }

        func eventLoad() async {
            output = .loading
            _ = await favoritesService.load()
            _ = await settingsService.load()
            switch await colorRepo.archive() {
            case .success(let colors):
                allColors = colors
                refreshPresentation()
            case .networkIssue:
                output = .presentError(.networkIssue)
            case .failure:
                output = .presentError(.genericFailure)
            }
        }

        func eventSetDisplayUnit(_ unit: ValueUnit) async {
            _ = await settingsService.setDisplayUnit(unit)
        }

        func eventSetAlertEnabled(_ enabled: Bool) async {
            _ = await settingsService.setAlertEnabled(enabled)
        }

        func eventSetAlertTime(_ time: DateComponents) async {
            _ = await settingsService.setAlertTime(time)
        }

        /// Per Flutter rules: re-emit the current snapshot of the catalog.
        /// Settings are observed off CotdAppState, so they don't need re-emission.
        private func refreshPresentation() {
            let saved = allColors.filter { state.favorites.contains($0.id) }
            output = .present(savedColors: saved)
        }
    }
}

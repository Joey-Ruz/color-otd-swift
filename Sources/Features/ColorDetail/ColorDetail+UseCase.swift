import Foundation
import Observation

extension ColorDetail {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private let favoritesService: FavoritesService

        /// Seeded immediately with the summary the caller already had,
        /// then upgraded to the full hydrated entity after `eventLoad`.
        private(set) var output: UseCaseOutput

        init(
            seed: ColorEntity,
            colorRepo: ColorRepository,
            favoritesService: FavoritesService
        ) {
            self.colorRepo = colorRepo
            self.favoritesService = favoritesService
            self.output = .presentColor(seed)
        }

        /// Hydrate the full entity (with lenses + recipe).
        /// On failure, keep showing the seed; only emit error if seed was already invalid.
        func eventLoad() async {
            guard case .presentColor(let seed) = output else { return }
            switch await colorRepo.color(byId: seed.id) {
            case .success(let full):
                output = .presentColor(full)
            case .networkIssue, .failure:
                break
            }
        }

        func eventToggleFavorite() async {
            guard case .presentColor(let color) = output else { return }
            _ = await favoritesService.toggle(color.id)
        }
    }
}

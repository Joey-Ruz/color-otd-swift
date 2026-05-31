import Foundation
import Observation

extension CategoryDetail {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private let favoritesService: FavoritesService
        private let initialColor: ColorEntity
        private let lensId: LensId

        private(set) var output: UseCaseOutput

        init(
            color: ColorEntity,
            lensId: LensId,
            colorRepo: ColorRepository,
            favoritesService: FavoritesService
        ) {
            self.colorRepo = colorRepo
            self.favoritesService = favoritesService
            self.initialColor = color
            self.lensId = lensId

            // Seed with whatever lens content is on the entity already.
            // If color has full lenses, this works immediately; otherwise we
            // fall through to a placeholder lens until eventLoad hydrates.
            let seedLens = color.lens(lensId)
                ?? BundledData.placeholderLenses(for: color).first { $0.id == lensId }!
            self.output = .presentLens(color: color, lens: seedLens)
        }

        /// Re-fetch the colour to get fully-loaded lens content.
        func eventLoad() async {
            switch await colorRepo.color(byId: initialColor.id) {
            case .success(let full):
                if let lens = full.lens(lensId) {
                    output = .presentLens(color: full, lens: lens)
                }
            case .networkIssue, .failure:
                break
            }
        }

        func eventToggleFavorite() async {
            guard case .presentLens(let color, _) = output else { return }
            _ = await favoritesService.toggle(color.id)
        }
    }
}

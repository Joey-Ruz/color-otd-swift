import Foundation
import Observation

extension Today {
    /// Today UseCase — fetches today's colour, owns the load lifecycle.
    /// Holds the ColorRepository + FavoritesService + CotdAppState.
    /// Per Flutter rules: emits via `output` (not via a stream subject —
    /// SwiftUI Observation tracks reads transitively, see Today+Presenter).
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private let favoritesService: FavoritesService
        private let state: CotdAppState

        /// The "stream" — read by Presenter's computed output.
        private(set) var output: UseCaseOutput = .loading

        init(
            colorRepo: ColorRepository,
            favoritesService: FavoritesService,
            state: CotdAppState = .instance
        ) {
            self.colorRepo = colorRepo
            self.favoritesService = favoritesService
            self.state = state
        }

        /// Initial load on appear. Sets `state.todayColor` so other features can
        /// observe today's color without re-hitting the repo.
        func eventLoad() async {
            output = .loading
            switch await colorRepo.todayColor() {
            case .success(let color):
                state.todayColor = color
                output = .presentColor(color)
            case .networkIssue:
                output = .presentError(.networkIssue)
            case .failure:
                output = .presentError(.genericFailure)
            }
        }

        /// Toggle favourite for the currently-shown colour.
        /// AppState mutation triggers a SwiftUI re-render via observation —
        /// no need to re-emit `output`.
        func eventToggleFavorite() async {
            guard case .presentColor(let color) = output else { return }
            _ = await favoritesService.toggle(color.id)
        }
    }
}

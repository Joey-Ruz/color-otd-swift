import Foundation
import Observation

extension Today {
    /// Today Presenter.
    ///
    /// Per architecture: `output` is a *computed* property that reads
    /// `useCase.output` + observable AppState properties. SwiftUI's observation
    /// tracking subscribes the Scene transitively — no explicit stream listener
    /// needed (Flutter's `useCase.stream.listen` plumbing disappears).
    @MainActor
    @Observable
    final class Presenter {
        let useCase: UseCase
        let state: CotdAppState
        var router: Router?

        var output: PresenterOutput { useCase.output.toPresenterOutput(state: state) }

        init(
            useCase: UseCase,
            state: CotdAppState = .instance,
            router: Router? = nil
        ) {
            self.useCase = useCase
            self.state = state
            self.router = router
        }

        // MARK: - Scene-facing events

        func eventViewAppeared() {
            Task { await useCase.eventLoad() }
        }

        func eventToggleFavorite() {
            Task { await useCase.eventToggleFavorite() }
        }

        func eventOpenLens(_ lensId: LensId) {
            guard case .presentColor(let color) = useCase.output else { return }
            router?.routeToLens(color: color, lensId: lensId)
        }

        func eventReplayReveal() {
            router?.routeReplayReveal()
        }
    }
}

// MARK: - Extension mapping
// Per Flutter rules: UseCaseOutput → PresenterOutput happens in a single extension
// method. The Presenter's `output` computed property is a single-line read.
extension Today.UseCaseOutput {
    @MainActor
    func toPresenterOutput(state: CotdAppState) -> Today.PresenterOutput {
        switch self {
        case .loading:
            return .loading
        case .presentColor(let color):
            return .showColor(Today.ViewModel(
                color: color,
                isFavorite: state.favorites.contains(color.id),
                displayUnit: state.displayUnit
            ))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

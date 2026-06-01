import Foundation
import Observation

extension ColorDetail {
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
    }
}

extension ColorDetail.UseCaseOutput {
    @MainActor
    func toPresenterOutput(state: CotdAppState) -> ColorDetail.PresenterOutput {
        switch self {
        case .presentColor(let color):
            return .showColor(ColorDetail.ViewModel(
                color: color,
                isFavorite: state.favorites.contains(color.id),
                displayUnit: state.displayUnit
            ))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

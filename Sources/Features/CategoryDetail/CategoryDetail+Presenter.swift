import Foundation
import Observation

extension CategoryDetail {
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
    }
}

extension CategoryDetail.UseCaseOutput {
    @MainActor
    func toPresenterOutput(state: CotdAppState) -> CategoryDetail.PresenterOutput {
        switch self {
        case .presentLens(let color, let lens):
            return .showLens(CategoryDetail.ViewModel(
                color: color,
                lens: lens,
                isFavorite: state.favorites.contains(color.id)
            ))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

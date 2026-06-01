import Foundation
import Observation

extension Profile {
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

        func eventSetDisplayUnit(_ unit: ValueUnit) {
            Task { await useCase.eventSetDisplayUnit(unit) }
        }

        func eventSetAlertEnabled(_ enabled: Bool) {
            Task { await useCase.eventSetAlertEnabled(enabled) }
        }

        func eventSetAlertTime(_ time: DateComponents) {
            Task { await useCase.eventSetAlertTime(time) }
        }

        func eventOpenColor(_ color: ColorEntity) {
            router?.routeToColor(color)
        }
    }
}

extension Profile.UseCaseOutput {
    @MainActor
    func toPresenterOutput(state: CotdAppState) -> Profile.PresenterOutput {
        switch self {
        case .loading:
            return .loading
        case .present(let savedColors):
            // Filter saved by current favorites (observation drives re-render on toggle).
            let live = savedColors.filter { state.favorites.contains($0.id) }
            return .show(Profile.ViewModel(
                savedColors: live,
                displayUnit: state.displayUnit,
                alertEnabled: state.alertEnabled,
                alertTime: state.alertTime
            ))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

import Foundation
import Observation

extension Reveal {
    @MainActor
    @Observable
    final class Presenter {
        let useCase: UseCase
        var router: Router?

        var output: PresenterOutput { useCase.output.toPresenterOutput }

        init(useCase: UseCase, router: Router? = nil) {
            self.useCase = useCase
            self.router = router
        }

        func eventViewAppeared() {
            Task { await useCase.eventLoad() }
        }

        /// Tap or auto-advance: animate out, then signal parent to remove.
        func eventDismiss() {
            useCase.eventBeginDismiss()
            Task {
                try? await Task.sleep(for: .milliseconds(480))
                router?.routeFinished()
            }
        }
    }
}

extension Reveal.UseCaseOutput {
    var toPresenterOutput: Reveal.PresenterOutput {
        switch self {
        case .loading:
            return .loading
        case .presentColor(let c):
            return .showReveal(color: c, dismissing: false)
        case .dismissing(let c):
            return .showReveal(color: c, dismissing: true)
        case .presentError(let m):
            return .showError(m)
        }
    }
}

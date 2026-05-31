import Foundation
import Observation

extension Archive {
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

        func eventOpenColor(_ color: ColorEntity) {
            router?.routeToColor(color)
        }
    }
}

extension Archive.UseCaseOutput {
    var toPresenterOutput: Archive.PresenterOutput {
        switch self {
        case .loading:
            return .loading
        case .presentArchive(let colors):
            return .showArchive(Archive.ViewModel(colors: colors))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

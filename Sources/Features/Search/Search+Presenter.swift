import Foundation
import Observation

extension Search {
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

        func eventQueryChanged(_ query: String) {
            Task { await useCase.eventQueryChanged(query) }
        }

        func eventOpenColor(_ color: ColorEntity) {
            router?.routeToColor(color)
        }
    }
}

extension Search.UseCaseOutput {
    var toPresenterOutput: Search.PresenterOutput {
        switch self {
        case .loading:
            return .loading
        case .presentBrowse(let themes):
            return .showBrowse(Search.BrowseViewModel(themes: themes))
        case .presentResults(let query, let colors):
            return .showResults(Search.ResultsViewModel(query: query, colors: colors))
        case .presentError(let m):
            return .showError(m)
        }
    }
}

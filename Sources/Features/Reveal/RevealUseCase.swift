import Foundation
import Observation

extension Reveal {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private(set) var output: UseCaseOutput = .loading

        init(colorRepo: ColorRepository) {
            self.colorRepo = colorRepo
        }

        func eventLoad() async {
            switch await colorRepo.todayColor() {
            case .success(let color):
                output = .presentColor(color)
            case .networkIssue:
                output = .presentError(.networkIssue)
            case .failure:
                output = .presentError(.genericFailure)
            }
        }

        /// Triggered by tap or auto-advance. Emits `.dismissing` to start the
        /// scale + fade animation; the Presenter's Router then removes the overlay.
        func eventBeginDismiss() {
            if case .presentColor(let color) = output {
                output = .dismissing(color)
            }
        }
    }
}

import Foundation
import Observation

extension Archive {
    @MainActor
    @Observable
    final class UseCase {
        private let colorRepo: ColorRepository
        private(set) var output: UseCaseOutput = .loading

        init(colorRepo: ColorRepository) {
            self.colorRepo = colorRepo
        }

        func eventLoad() async {
            output = .loading
            switch await colorRepo.archive() {
            case .success(let colors):
                output = .presentArchive(colors)
            case .networkIssue:
                output = .presentError(.networkIssue)
            case .failure:
                output = .presentError(.genericFailure)
            }
        }
    }
}

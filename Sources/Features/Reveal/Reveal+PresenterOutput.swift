import Foundation

extension Reveal {
    enum PresenterOutput: Equatable {
        case loading
        case showReveal(color: ColorEntity, dismissing: Bool)
        case showError(MessageType)
    }
}

import Foundation

extension Reveal {
    enum UseCaseOutput: Equatable {
        case loading
        case presentColor(ColorEntity)
        case dismissing(ColorEntity)
        case presentError(MessageType)
    }
}

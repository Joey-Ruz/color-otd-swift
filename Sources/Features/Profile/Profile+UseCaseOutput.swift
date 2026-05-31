import Foundation

extension Profile {
    enum UseCaseOutput: Equatable {
        case loading
        case present(savedColors: [ColorEntity])
        case presentError(MessageType)
    }
}

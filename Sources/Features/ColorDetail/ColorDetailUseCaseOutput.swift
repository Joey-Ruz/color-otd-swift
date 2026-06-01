import Foundation

extension ColorDetail {
    enum UseCaseOutput: Equatable {
        /// Always present — seeded from the summary the caller already had.
        /// Re-emitted with fuller content once the repository hydrates the entity.
        case presentColor(ColorEntity)
        case presentError(MessageType)
    }
}

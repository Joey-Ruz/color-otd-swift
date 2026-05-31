import Foundation

extension Search {
    enum UseCaseOutput: Equatable {
        case loading
        case presentBrowse([ResolvedTheme])
        case presentResults(query: String, colors: [ColorEntity])
        case presentError(MessageType)
    }
}

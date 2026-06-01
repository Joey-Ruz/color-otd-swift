import Foundation

extension Search {
    @MainActor
    protocol Router: AnyObject {
        func routeToColor(_ color: ColorEntity)
    }
}

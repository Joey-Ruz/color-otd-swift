import Foundation

extension Archive {
    @MainActor
    protocol Router: AnyObject {
        func routeToColor(_ color: ColorEntity)
    }
}

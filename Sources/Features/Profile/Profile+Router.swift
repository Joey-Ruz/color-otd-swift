import Foundation

extension Profile {
    @MainActor
    protocol Router: AnyObject {
        func routeToColor(_ color: ColorEntity)
    }
}

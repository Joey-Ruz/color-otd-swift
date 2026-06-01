import Foundation

extension ColorDetail {
    @MainActor
    protocol Router: AnyObject {
        func routeToLens(color: ColorEntity, lensId: LensId)
    }
}

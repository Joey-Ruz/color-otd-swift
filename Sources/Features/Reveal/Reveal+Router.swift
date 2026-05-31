import Foundation

extension Reveal {
    @MainActor
    protocol Router: AnyObject {
        func routeFinished()
    }
}

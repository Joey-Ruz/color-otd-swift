import SwiftUI
import Observation

/// Owns the per-tab NavigationPath and implements every feature's Router protocol.
/// One class implements multiple Routers because their signatures align:
///   Today.Router + ColorDetail.Router → routeToLens
///   Archive.Router + Search.Router + Profile.Router → routeToColor
///   Reveal.Router → routeFinished
@MainActor
@Observable
final class TabHostState {
    var selectedTab: TabKind = .today
    var todayPath = NavigationPath()
    var archivePath = NavigationPath()
    var searchPath = NavigationPath()
    var profilePath = NavigationPath()
    var revealCompleted: Bool = false

    fileprivate func push(_ destination: CotdDestination) {
        switch selectedTab {
        case .today: todayPath.append(destination)
        case .archive: archivePath.append(destination)
        case .search: searchPath.append(destination)
        case .profile: profilePath.append(destination)
        }
    }
}

extension TabHostState: Today.Router, ColorDetail.Router {
    func routeToLens(color: ColorEntity, lensId: LensId) {
        push(.categoryDetail(color: color, lensId: lensId))
    }

    /// Re-show the Reveal overlay (used by the replay button on Today).
    func routeReplayReveal() {
        withAnimation(.easeInOut(duration: 0.3)) {
            revealCompleted = false
        }
    }
}

extension TabHostState: Archive.Router, Search.Router, Profile.Router {
    func routeToColor(_ color: ColorEntity) {
        push(.colorDetail(color))
    }
}

extension TabHostState: Reveal.Router {
    func routeFinished() {
        withAnimation(.easeInOut(duration: 0.4)) {
            revealCompleted = true
        }
    }
}

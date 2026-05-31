import Foundation

/// Every Scene-level alert / toast message in the app is represented here.
/// Never hardcode alert strings in a Scene — add a case here and route through
/// `PlatformSpecific.showCustomAlert(messageType:)`.
enum MessageType: Hashable {
    case networkIssue
    case genericFailure
    case notificationPermissionDenied
    case notificationsRescheduled
    case favoriteAdded(colorName: String)
    case favoriteRemoved(colorName: String)
}

extension MessageType {
    var title: String {
        switch self {
        case .networkIssue: "No connection"
        case .genericFailure: "Something went wrong"
        case .notificationPermissionDenied: "Notifications blocked"
        case .notificationsRescheduled: "Daily alert updated"
        case .favoriteAdded: "Saved"
        case .favoriteRemoved: "Removed"
        }
    }

    var body: String {
        switch self {
        case .networkIssue:
            "Try again when you’re back online."
        case .genericFailure:
            "Please try again in a moment."
        case .notificationPermissionDenied:
            "Allow notifications in Settings to receive your daily colour."
        case .notificationsRescheduled:
            "You’ll get the next colour at your new time."
        case .favoriteAdded(let name):
            "\(name) added to your collection."
        case .favoriteRemoved(let name):
            "\(name) removed from your collection."
        }
    }
}

import Foundation
import UserNotifications

/// Wraps UNUserNotificationCenter for scheduling the daily-colour alert.
@MainActor
final class NotificationService {
    private static let identifier = "cotd.daily-color"

    /// Prompt for permission. Returns true if granted (or already granted).
    func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        if settings.authorizationStatus == .authorized {
            return true
        }
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            return false
        }
    }

    /// Replace any existing daily notification with a fresh schedule at `time`.
    /// Body mentions the upcoming colour name + hex when available.
    func scheduleDaily(at time: DateComponents, hintColor: ColorEntity?) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [Self.identifier])

        let content = UNMutableNotificationContent()
        content.title = "Today’s colour"
        if let hint = hintColor {
            content.body = "\(hint.name) · \(hint.hex.uppercased())"
        } else {
            content.body = "A new colour awaits."
        }
        content.sound = .default

        var components = DateComponents()
        components.hour = time.hour ?? 8
        components.minute = time.minute ?? 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: Self.identifier, content: content, trigger: trigger)
        do {
            try await center.add(request)
        } catch {
            // Silent fail — user will see no daily alert until next attempt.
        }
    }

    func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [Self.identifier])
    }
}

import Foundation

/// Owns the midnight rollover Task — refreshes `CotdAppState.todayColor`
/// whenever the local calendar day flips while the app is running.
@MainActor
final class DailyColorScheduler {
    private let colorRepo: ColorRepository
    private let dailyService: DailyColorService
    private let state: CotdAppState
    private var task: Task<Void, Never>?

    init(
        colorRepo: ColorRepository,
        dailyService: DailyColorService,
        state: CotdAppState = .instance
    ) {
        self.colorRepo = colorRepo
        self.dailyService = dailyService
        self.state = state
    }

    /// Refresh once now, then loop indefinitely waiting for the next midnight.
    func start() {
        task?.cancel()
        task = Task { @MainActor [weak self] in
            await self?.refresh()
            while !Task.isCancelled {
                guard let nextMidnight = Self.nextMidnight() else { return }
                let delay = nextMidnight.timeIntervalSinceNow
                if delay > 0 {
                    try? await Task.sleep(for: .seconds(delay))
                }
                if Task.isCancelled { return }
                await self?.refresh()
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    private func refresh() async {
        switch await dailyService.colorId(for: Date()) {
        case .success(let id):
            switch await colorRepo.color(byId: id) {
            case .success(let color):
                state.todayColor = color
            case .networkIssue, .failure:
                break
            }
        case .networkIssue, .failure:
            break
        }
    }

    private static func nextMidnight() -> Date? {
        Calendar.current.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0),
            matchingPolicy: .nextTime
        )
    }
}

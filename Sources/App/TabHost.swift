import SwiftUI

/// Root tab host. Owns the four NavigationStacks, the Reveal overlay,
/// the daily-color scheduler, and the notification service.
struct TabHost: View {
    @State private var router = TabHostState()
    @State private var state = CotdAppState.instance
    @State private var scheduler: DailyColorScheduler = {
        DailyColorScheduler(
            colorRepo: MemoryColorRepository(),
            dailyService: MemoryDailyColorService()
        )
    }()
    @State private var notifications = NotificationService()
    @Environment(\.scenePhase) private var scenePhase

    private let colorRepo: ColorRepository = MemoryColorRepository()
    private let favoritesService: FavoritesService = MemoryFavoritesService()
    private let settingsService: SettingsService = MemorySettingsService()

    var body: some View {
        ZStack {
            tabs
            if !router.revealCompleted {
                Reveal.Assembly.build(
                    colorRepo: colorRepo,
                    router: router
                )
                .transition(.opacity)
                .zIndex(10)
            }
        }
        .task {
            await favoritesService.load()
            await settingsService.load()
            scheduler.start()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                Task { await rescheduleNotification() }
            }
        }
        .onChange(of: state.alertEnabled) { _, _ in
            Task { await rescheduleNotification() }
        }
        .onChange(of: state.alertTime) { _, _ in
            Task { await rescheduleNotification() }
        }
    }

    // MARK: - Tabs

    private var tabs: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Today", systemImage: "paintpalette.fill", value: TabKind.today) {
                NavigationStack(path: $router.todayPath) {
                    Today.Assembly.build(
                        colorRepo: colorRepo,
                        favoritesService: favoritesService,
                        router: router
                    )
                    .navigationDestination(for: CotdDestination.self, destination: destinationView)
                }
            }

            Tab("Archive", systemImage: "swatchpalette.fill", value: TabKind.archive) {
                NavigationStack(path: $router.archivePath) {
                    Archive.Assembly.build(colorRepo: colorRepo, router: router)
                        .navigationDestination(for: CotdDestination.self, destination: destinationView)
                }
            }

            Tab("Search", systemImage: "magnifyingglass", value: TabKind.search) {
                NavigationStack(path: $router.searchPath) {
                    Search.Assembly.build(colorRepo: colorRepo, router: router)
                        .navigationDestination(for: CotdDestination.self, destination: destinationView)
                }
            }

            Tab("Profile", systemImage: "person.crop.circle.fill", value: TabKind.profile) {
                NavigationStack(path: $router.profilePath) {
                    Profile.Assembly.build(
                        colorRepo: colorRepo,
                        favoritesService: favoritesService,
                        settingsService: settingsService,
                        router: router
                    )
                    .navigationDestination(for: CotdDestination.self, destination: destinationView)
                }
            }
        }
        .tint(CotdColor.ink)
    }

    @ViewBuilder
    private func destinationView(for destination: CotdDestination) -> some View {
        switch destination {
        case .colorDetail(let color):
            ColorDetail.Assembly.build(
                seed: color,
                colorRepo: colorRepo,
                favoritesService: favoritesService,
                router: router
            )
        case .categoryDetail(let color, let lensId):
            CategoryDetail.Assembly.build(
                color: color,
                lensId: lensId,
                colorRepo: colorRepo,
                favoritesService: favoritesService
            )
        }
    }

    // MARK: - Notification rescheduling

    private func rescheduleNotification() async {
        guard state.alertEnabled else {
            notifications.cancel()
            return
        }
        let granted = await notifications.requestAuthorization()
        guard granted else { return }
        await notifications.scheduleDaily(at: state.alertTime, hintColor: state.todayColor)
    }
}

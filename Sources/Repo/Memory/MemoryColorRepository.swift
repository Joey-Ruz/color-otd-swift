import Foundation

/// In-memory implementation backed by the bundled catalog.
/// Per Flutter rules: scaffolded from the start so screens render end-to-end
/// without any backend connectivity.
struct MemoryColorRepository: ColorRepository {
    /// Tiny simulated network delay so loading states are observable in dev.
    var simulatedDelay: Duration = .milliseconds(120)

    func todayColor() async -> CotdResult<ColorEntity> {
        await delay()
        guard let color = BundledData.fullColor(id: "prussian-blue") else { return .failure }
        return .success(color)
    }

    func color(byId id: ColorId) async -> CotdResult<ColorEntity> {
        await delay()
        guard let color = BundledData.fullColor(id: id) else { return .failure }
        return .success(color)
    }

    func archive() async -> CotdResult<[ColorEntity]> {
        await delay()
        let entries = BundledData.archiveSummaries.compactMap { row in
            BundledData.summaryColor(id: row.id)
        }
        return .success(entries)
    }

    func search(_ query: String) async -> CotdResult<[ColorEntity]> {
        await delay()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return .success([]) }
        let matches = BundledData.archiveSummaries.compactMap { row -> ColorEntity? in
            let nameMatches = row.name.lowercased().contains(trimmed)
            let hexMatches = row.hex.lowercased().contains(trimmed)
            guard nameMatches || hexMatches else { return nil }
            return BundledData.summaryColor(id: row.id)
        }
        return .success(matches)
    }

    func themes() async -> CotdResult<[ThemeEntity]> {
        await delay()
        return .success(BundledData.themes)
    }

    // MARK: -

    private func delay() async {
        try? await Task.sleep(for: simulatedDelay)
    }
}

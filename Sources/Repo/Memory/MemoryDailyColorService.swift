import Foundation

/// Deterministic local picker — same colour for every device on the same date.
/// Indexes into the bundled archive by (date - epoch) mod count.
struct MemoryDailyColorService: DailyColorService {
    /// Anchor day: every date past this rolls forward through the catalog.
    static let epoch: Date = {
        var c = DateComponents()
        c.year = 2026
        c.month = 5
        c.day = 28
        c.timeZone = .gmt
        return Calendar(identifier: .gregorian).date(from: c) ?? Date()
    }()

    func colorId(for date: Date) async -> CotdResult<ColorId> {
        let catalog = BundledData.archiveSummaries
        guard !catalog.isEmpty else { return .failure }

        let cal = Calendar(identifier: .gregorian)
        let epochDay = cal.startOfDay(for: Self.epoch)
        let targetDay = cal.startOfDay(for: date)
        let days = cal.dateComponents([.day], from: epochDay, to: targetDay).day ?? 0

        // Wrap: positive or negative days both index into the catalog.
        let n = catalog.count
        let idx = ((days % n) + n) % n
        return .success(catalog[idx].id)
    }
}

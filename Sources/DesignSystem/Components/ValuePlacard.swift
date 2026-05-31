import SwiftUI

/// One of the three small placards rendered over the colour hero —
/// a label ("HEX") above a monospace value ("#003153").
struct ValuePlacard: View {
    let label: String
    let value: String
    let onColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label.uppercased())
                .font(CotdFont.valuePlacardLabel)
                .tracking(9.5 * 0.2)
                .foregroundStyle(onColor.opacity(0.5))
            Text(value)
                .font(CotdFont.monoValue)
                .tracking(14 * 0.01)
                .foregroundStyle(onColor.opacity(0.95))
        }
    }
}

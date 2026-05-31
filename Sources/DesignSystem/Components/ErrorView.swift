import SwiftUI

/// Quiet error state shown when a Scene's load fails.
struct ErrorView: View {
    let message: MessageType
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: Spacing.s16) {
            Text(message.title)
                .font(CotdFont.titleMedium)
                .foregroundStyle(CotdColor.ink)
            Text(message.body)
                .font(CotdFont.body)
                .foregroundStyle(CotdColor.inkMute)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 320)
            Button(action: onRetry) {
                Text("Try again")
                    .font(CotdFont.metadata)
                    .foregroundStyle(CotdColor.paper)
                    .padding(.horizontal, Spacing.s24)
                    .padding(.vertical, Spacing.s12)
                    .background(CotdColor.ink)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.top, Spacing.s8)
        }
        .padding(.horizontal, Spacing.gutter)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

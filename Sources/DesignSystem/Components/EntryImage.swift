import SwiftUI

/// Hero image for a lens entry. Loads `entry.imageUrl` via AsyncImage if set;
/// otherwise renders the StripePlaceholder fallback. Credit chip overlays the
/// bottom-right corner when `entry.imageCredit` is present.
struct EntryImage: View {
    let entry: LensEntryEntity
    var height: CGFloat = 232

    var body: some View {
        Group {
            if let urlString = entry.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url, transaction: .init(animation: .easeInOut(duration: 0.25))) { phase in
                    switch phase {
                    case .empty:
                        StripePlaceholder(label: entry.imageRef, height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        StripePlaceholder(label: entry.imageRef, height: height)
                    @unknown default:
                        StripePlaceholder(label: entry.imageRef, height: height)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .overlay(alignment: .bottomTrailing) {
                    if let credit = entry.imageCredit {
                        Text(credit)
                            .font(CotdFont.monoMicro)
                            .tracking(10 * 0.04)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.black.opacity(0.55))
                            .clipShape(Capsule())
                            .padding(8)
                    }
                }
            } else {
                StripePlaceholder(label: entry.imageRef, height: height)
            }
        }
    }
}

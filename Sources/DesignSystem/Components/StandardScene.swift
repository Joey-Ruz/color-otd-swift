import SwiftUI

/// The base wrapper for every Scene. Applies paper background, safe-area handling,
/// and an optional waiting overlay. Per the Flutter rules, every Scene wraps its
/// content in `StandardScene { ... }`; ad-hoc SafeArea / padding in a Scene is a smell.
///
/// Usage:
///   var body: some View {
///       StandardScene(isWaiting: presenter.output.isLoading) {
///           ...scene content...
///       }
///   }
struct StandardScene<Content: View>: View {
    let isWaiting: Bool
    let extendsUnderTop: Bool
    @ViewBuilder let content: () -> Content

    init(
        isWaiting: Bool = false,
        extendsUnderTop: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isWaiting = isWaiting
        self.extendsUnderTop = extendsUnderTop
        self.content = content
    }

    var body: some View {
        ZStack {
            CotdColor.paper
                .ignoresSafeArea()

            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(edges: extendsUnderTop ? .top : [])

            if isWaiting {
                ShowWaiting()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: isWaiting)
    }
}

/// Standard waiting overlay — a quiet, low-chrome spinner over a paper-tinted scrim.
struct ShowWaiting: View {
    var body: some View {
        ZStack {
            CotdColor.paper.opacity(0.6)
                .ignoresSafeArea()
            ProgressView()
                .tint(CotdColor.ink)
                .controlSize(.large)
        }
        .accessibilityElement()
        .accessibilityLabel("Loading")
    }
}

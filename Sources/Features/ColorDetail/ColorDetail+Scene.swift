import SwiftUI

extension ColorDetail {
    /// ColorDetail Scene — same shape as Today, but with a back button overlay
    /// and the "Archive Entry" masthead label.
    struct Scene: View {
        @State var presenter: Presenter
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            StandardScene(extendsUnderTop: true) {
                switch presenter.output {
                case .showColor(let vm):
                    ColorHeroLayout(
                        topLabel: "Archive Entry",
                        color: vm.color,
                        isFavorite: vm.isFavorite,
                        displayUnit: vm.displayUnit,
                        onToggleFavorite: presenter.eventToggleFavorite,
                        onOpenLens: presenter.eventOpenLens,
                        onBack: { dismiss() }
                    )
                case .showError(let message):
                    ErrorView(message: message, onRetry: presenter.eventViewAppeared)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { presenter.eventViewAppeared() }
        }
    }
}

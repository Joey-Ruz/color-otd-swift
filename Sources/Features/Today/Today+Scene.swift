import SwiftUI

extension Today {
    /// Today Scene — wraps content in StandardScene and switches exhaustively
    /// on PresenterOutput. Status-bar light over the colour field.
    struct Scene: View {
        @State var presenter: Presenter

        var body: some View {
            StandardScene(
                isWaiting: presenter.output.isLoading,
                extendsUnderTop: true
            ) {
                switch presenter.output {
                case .loading:
                    Color.clear
                case .showColor(let vm):
                    ColorHeroLayout(
                        topLabel: "Colour of the Day",
                        color: vm.color,
                        isFavorite: vm.isFavorite,
                        displayUnit: vm.displayUnit,
                        onToggleFavorite: presenter.eventToggleFavorite,
                        onOpenLens: presenter.eventOpenLens,
                        onReplay: presenter.eventReplayReveal
                    )
                case .showError(let message):
                    ErrorView(
                        message: message,
                        onRetry: presenter.eventViewAppeared
                    )
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .statusBarHidden(false)
            .onAppear { presenter.eventViewAppeared() }
        }
    }
}

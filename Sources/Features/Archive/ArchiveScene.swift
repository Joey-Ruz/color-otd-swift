import SwiftUI

extension Archive {
    struct Scene: View {
        @State var presenter: Presenter

        private let columns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]

        var body: some View {
            StandardScene(isWaiting: presenter.output.isLoading) {
                switch presenter.output {
                case .loading:
                    Color.clear
                case .showArchive(let vm):
                    content(vm: vm)
                case .showError(let message):
                    ErrorView(message: message, onRetry: presenter.eventViewAppeared)
                }
            }
            .onAppear { presenter.eventViewAppeared() }
        }

        @ViewBuilder
        private func content(vm: ViewModel) -> some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header(count: vm.colors.count)
                    Rule().padding(.horizontal, Spacing.gutter)
                    LazyVGrid(columns: columns, spacing: 26) {
                        ForEach(vm.colors) { color in
                            SwatchTile(
                                name: color.name,
                                hex: color.hex,
                                date: color.dateShort,
                                color: color.color,
                                onColor: color.onColor,
                                aspect: 0.86,
                                onTap: { presenter.eventOpenColor(color) }
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.gutter)
                    .padding(.top, Spacing.s24)
                    .padding(.bottom, Spacing.s130)
                }
            }
            .scrollIndicators(.hidden)
        }

        private func header(count: Int) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                SectionLabel("The collection")
                Text("Archive")
                    .font(CotdFont.displaySmall)
                    .tracking(44 * -0.02)
                    .foregroundStyle(CotdColor.ink)
                Text("\(count) colours, one for every day. Tap any to revisit its full reading.")
                    .font(CotdFont.caption)
                    .foregroundStyle(CotdColor.inkMute)
                    .lineSpacing(2)
            }
            .padding(.horizontal, Spacing.gutter)
            .padding(.top, Spacing.s70)
            .padding(.bottom, Spacing.s22)
        }
    }
}

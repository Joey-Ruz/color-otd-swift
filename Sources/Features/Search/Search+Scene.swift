import SwiftUI

extension Search {
    struct Scene: View {
        @State var presenter: Presenter
        @State private var query: String = ""

        private let resultColumns = [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16),
        ]

        var body: some View {
            StandardScene(isWaiting: presenter.output.isLoading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                        switch presenter.output {
                        case .loading:
                            Color.clear
                        case .showBrowse(let vm):
                            browse(vm: vm)
                        case .showResults(let vm):
                            results(vm: vm)
                        case .showError(let message):
                            ErrorView(message: message, onRetry: presenter.eventViewAppeared)
                                .frame(maxWidth: .infinity)
                                .padding(.top, Spacing.s64)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .onAppear { presenter.eventViewAppeared() }
            .onChange(of: query) { _, new in presenter.eventQueryChanged(new) }
        }

        // MARK: - Header + search field

        private var header: some View {
            VStack(alignment: .leading, spacing: 18) {
                Text("Search")
                    .font(CotdFont.displaySmall)
                    .tracking(44 * -0.02)
                    .foregroundStyle(CotdColor.ink)

                HStack(spacing: 10) {
                    TabIcon(kind: .search, active: false, size: 18)
                    TextField("Name, hex, or a theme…", text: $query)
                        .font(CotdFont.input)
                        .foregroundStyle(CotdColor.ink)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                    if !query.isEmpty {
                        Button("clear") { query = "" }
                            .font(CotdFont.monoSmall)
                            .foregroundStyle(CotdColor.inkFaint)
                            .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.inputField)
                        .fill(CotdColor.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.inputField)
                        .stroke(CotdColor.line, lineWidth: 1)
                )
            }
            .padding(.horizontal, Spacing.gutter)
            .padding(.top, Spacing.s70)
            .padding(.bottom, Spacing.s18)
        }

        // MARK: - Browse (curated themes)

        @ViewBuilder
        private func browse(vm: BrowseViewModel) -> some View {
            VStack(alignment: .leading, spacing: 0) {
                SectionLabel("Browse by theme")
                    .padding(.horizontal, Spacing.gutter)
                    .padding(.vertical, 14)

                ForEach(Array(vm.themes.enumerated()), id: \.element.id) { idx, theme in
                    VStack(alignment: .leading, spacing: 11) {
                        Text(theme.label)
                            .font(CotdFont.recipeNote)
                            .foregroundStyle(CotdColor.ink)
                        HStack(spacing: 10) {
                            ForEach(theme.colors) { color in
                                Button(action: { presenter.eventOpenColor(color) }) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Rectangle()
                                            .fill(color.color)
                                            .frame(height: 66)
                                            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.tile))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: CornerRadius.tile)
                                                    .stroke(Color.black.opacity(0.04), lineWidth: 1)
                                            )
                                        Text(color.name)
                                            .font(CotdFont.captionSmall)
                                            .foregroundStyle(CotdColor.inkMute)
                                            .lineLimit(1)
                                    }
                                }
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.gutter)
                    .padding(.bottom, 26)

                    if idx < vm.themes.count - 1 {
                        Rule().padding(.horizontal, Spacing.gutter)
                    }
                }
            }
            .padding(.bottom, Spacing.s130)
        }

        // MARK: - Results grid

        @ViewBuilder
        private func results(vm: ResultsViewModel) -> some View {
            VStack(alignment: .leading, spacing: 0) {
                SectionLabel("\(vm.colors.count) result\(vm.colors.count == 1 ? "" : "s")")
                    .padding(.horizontal, Spacing.gutter)
                    .padding(.vertical, 16)

                if vm.colors.isEmpty {
                    Text("Nothing matches “\(vm.query).”")
                        .font(CotdFont.lensIntro)
                        .foregroundStyle(CotdColor.inkMute)
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.vertical, Spacing.s24)
                } else {
                    LazyVGrid(columns: resultColumns, spacing: 26) {
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
                }
            }
            .padding(.bottom, Spacing.s130)
        }
    }
}

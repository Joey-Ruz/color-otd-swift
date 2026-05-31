import SwiftUI

extension CategoryDetail {
    struct Scene: View {
        @State var presenter: Presenter
        @Environment(\.dismiss) private var dismiss

        var body: some View {
            StandardScene(extendsUnderTop: true) {
                switch presenter.output {
                case .showLens(let vm):
                    content(vm: vm)
                case .showError(let message):
                    ErrorView(message: message, onRetry: presenter.eventViewAppeared)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { presenter.eventViewAppeared() }
        }

        @ViewBuilder
        private func content(vm: ViewModel) -> some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    masthead(vm: vm)
                    entries(vm: vm)
                }
            }
            .scrollIndicators(.hidden)
        }

        // MARK: - Masthead band in the day colour

        @ViewBuilder
        private func masthead(vm: ViewModel) -> some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    GlassButton(style: .light, action: { dismiss() }) {
                        BackGlyph(color: vm.color.onColor)
                    }
                    Spacer()
                    Text(vm.color.name.uppercased())
                        .font(CotdFont.mastheadLabel)
                        .tracking(11 * 0.18)
                        .foregroundStyle(vm.color.onColor.opacity(0.7))
                    Spacer()
                    GlassButton(style: .light, action: presenter.eventToggleFavorite) {
                        HeartGlyph(filled: vm.isFavorite, color: vm.color.onColor)
                    }
                }
                .padding(.top, Spacing.s64 - 4)

                HStack(spacing: 12) {
                    LensGlyph(kind: vm.lens.glyph, color: vm.color.onColor, size: 26, strokeWidth: 1.5)
                    Text(vm.lens.label)
                        .font(CotdFont.displaySmall)
                        .tracking(44 * -0.015)
                        .foregroundStyle(vm.color.onColor)
                }
                .padding(.top, Spacing.s30)

                Text(vm.lens.intro)
                    .font(CotdFont.lensIntro)
                    .foregroundStyle(vm.color.onColor.opacity(0.9))
                    .lineSpacing(3)
                    .frame(maxWidth: 340, alignment: .leading)
                    .padding(.top, Spacing.s16)
                    .padding(.bottom, Spacing.s30)
            }
            .padding(.horizontal, Spacing.gutter)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(vm.color.color)
        }

        // MARK: - Editorial entries

        @ViewBuilder
        private func entries(vm: ViewModel) -> some View {
            VStack(spacing: 0) {
                ForEach(Array(vm.lens.entries.enumerated()), id: \.element.id) { idx, entry in
                    VStack(alignment: .leading, spacing: 0) {
                        StripePlaceholder(label: entry.imageRef, height: 232)
                            .padding(.horizontal, Spacing.gutter)

                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(String(format: "%02d", idx + 1))
                                .font(CotdFont.monoIndex)
                                .foregroundStyle(vm.color.color)
                            Text(entry.meta.uppercased())
                                .font(CotdFont.mastheadLabel)
                                .tracking(11 * 0.14)
                                .foregroundStyle(CotdColor.inkMute)
                        }
                        .padding(.horizontal, Spacing.gutter)
                        .padding(.top, Spacing.s18)

                        Text(entry.title)
                            .font(CotdFont.titleMedium)
                            .tracking(28 * -0.01)
                            .foregroundStyle(CotdColor.ink)
                            .lineSpacing(2)
                            .padding(.horizontal, Spacing.gutter)
                            .padding(.top, Spacing.s6)

                        Text(entry.blurb)
                            .font(CotdFont.body)
                            .foregroundStyle(Color(hex: 0x403D37))
                            .lineSpacing(4)
                            .padding(.horizontal, Spacing.gutter)
                            .padding(.top, Spacing.s11)

                        if idx < vm.lens.entries.count - 1 {
                            Rule()
                                .padding(.horizontal, Spacing.gutter)
                                .padding(.top, Spacing.s30)
                        }
                    }
                    .padding(.top, Spacing.s30)
                }

                Text("End of \(vm.lens.label.lowercased())".uppercased())
                    .font(CotdFont.monoSwatch)
                    .tracking(10.5 * 0.1)
                    .foregroundStyle(CotdColor.inkFaint)
                    .padding(.top, Spacing.s34)
            }
            .padding(.bottom, Spacing.s130)
        }
    }
}

import SwiftUI

extension Profile {
    struct Scene: View {
        @State var presenter: Presenter

        private let savedColumns = [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12),
        ]

        var body: some View {
            StandardScene(isWaiting: presenter.output.isLoading) {
                switch presenter.output {
                case .loading:
                    Color.clear
                case .show(let vm):
                    content(vm: vm)
                case .showError(let message):
                    ErrorView(message: message, onRetry: presenter.eventViewAppeared)
                }
            }
            .onAppear { presenter.eventViewAppeared() }
        }

        // MARK: - Content

        @ViewBuilder
        private func content(vm: ViewModel) -> some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    Rule().padding(.horizontal, Spacing.gutter)
                    savedSection(vm: vm)
                    settingsSection(vm: vm)
                }
            }
            .scrollIndicators(.hidden)
        }

        // MARK: - Identity header

        private var header: some View {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(hex: 0xE7E3D7))
                        .frame(width: 60, height: 60)
                    Text("A")
                        .font(CotdFont.headline)
                        .foregroundStyle(CotdColor.inkMute)
                }
                .overlay(Circle().stroke(CotdColor.line, lineWidth: 1))

                VStack(alignment: .leading, spacing: 4) {
                    SectionLabel("Your collection")
                    Text("Profile")
                        .font(CotdFont.titleLarge)
                        .tracking(36 * -0.02)
                        .foregroundStyle(CotdColor.ink)
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.gutter)
            .padding(.top, Spacing.s70)
            .padding(.bottom, Spacing.s24)
        }

        // MARK: - Saved colours

        @ViewBuilder
        private func savedSection(vm: ViewModel) -> some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    SectionLabel("Saved colours")
                    Spacer()
                    Text("\(vm.savedColors.count) kept")
                        .font(CotdFont.monoIndex)
                        .foregroundStyle(CotdColor.inkFaint)
                }

                if vm.savedColors.isEmpty {
                    Text("No colours saved yet.")
                        .font(CotdFont.lensIntro)
                        .foregroundStyle(CotdColor.inkMute)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Spacing.s30)
                } else {
                    LazyVGrid(columns: savedColumns, spacing: 20) {
                        ForEach(vm.savedColors) { color in
                            SwatchTile(
                                name: color.name,
                                hex: color.hex,
                                date: color.dateShort,
                                color: color.color,
                                onColor: color.onColor,
                                aspect: 1,
                                showFavoriteOverlay: true,
                                isFavorite: true,
                                onTap: { presenter.eventOpenColor(color) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.gutter)
            .padding(.top, Spacing.s24)
            .padding(.bottom, Spacing.s8)
        }

        // MARK: - Settings

        @ViewBuilder
        private func settingsSection(vm: ViewModel) -> some View {
            VStack(alignment: .leading, spacing: 26) {
                dailyColourGroup(vm: vm)
                displayGroup(vm: vm)
                aboutGroup
                tagline
            }
            .padding(.horizontal, Spacing.gutter - 4)
            .padding(.top, Spacing.s24)
            .padding(.bottom, Spacing.s130)
        }

        // MARK: Sub-groups

        @ViewBuilder
        private func dailyColourGroup(vm: ViewModel) -> some View {
            SettingsGroup(header: "Daily colour") {
                VStack(spacing: 0) {
                    SettingsRow(label: "Daily alert", sub: "A new colour, every morning") {
                        Toggle("", isOn: Binding(
                            get: { vm.alertEnabled },
                            set: { presenter.eventSetAlertEnabled($0) }
                        ))
                        .labelsHidden()
                        .tint(CotdColor.ink)
                    }
                    Rule(.soft)
                    SettingsRow(label: "Alert time", last: true) {
                        DatePicker("", selection: alertTimeBinding(vm: vm),
                                   displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                }
            }
        }

        @ViewBuilder
        private func displayGroup(vm: ViewModel) -> some View {
            SettingsGroup(header: "Display") {
                VStack(alignment: .leading, spacing: 11) {
                    Text("Colour values")
                        .font(CotdFont.settingRow)
                        .foregroundStyle(CotdColor.ink)
                    HStack(spacing: 8) {
                        ForEach(ValueUnit.allCases) { unit in
                            Button(action: { presenter.eventSetDisplayUnit(unit) }) {
                                Text(unit.rawValue)
                                    .font(CotdFont.monoChip)
                                    .foregroundStyle(unit == vm.displayUnit ? CotdColor.paper : CotdColor.inkMute)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .background(
                                        RoundedRectangle(cornerRadius: CornerRadius.chip)
                                            .fill(unit == vm.displayUnit ? CotdColor.ink : .clear)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: CornerRadius.chip)
                                            .stroke(unit == vm.displayUnit ? CotdColor.ink : CotdColor.line, lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(15)
            }
        }

        @ViewBuilder
        private var aboutGroup: some View {
            SettingsGroup(header: "About") {
                VStack(spacing: 0) {
                    SettingsRow(label: "The story of Color OTD") {
                        Chevron()
                    }
                    Rule(.soft)
                    SettingsRow(label: "Sources & credits",
                                sub: "Editorial, imagery and pigment data") {
                        Chevron()
                    }
                    Rule(.soft)
                    SettingsRow(label: "Version", last: true) {
                        Text("1.0.0")
                            .font(CotdFont.monoChip)
                            .foregroundStyle(CotdColor.inkFaint)
                    }
                }
            }
        }

        private var tagline: some View {
            Text("One colour at a time.")
                .font(CotdFont.italicSmall)
                .foregroundStyle(CotdColor.inkFaint)
                .frame(maxWidth: .infinity)
                .padding(.top, Spacing.s10)
        }

        // MARK: -

        private func alertTimeBinding(vm: ViewModel) -> Binding<Date> {
            Binding(
                get: {
                    let cal = Calendar.current
                    var c = vm.alertTime
                    if c.year == nil { c.year = 2026 }
                    if c.month == nil { c.month = 1 }
                    if c.day == nil { c.day = 1 }
                    return cal.date(from: c) ?? Date()
                },
                set: { newDate in
                    let comps = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                    presenter.eventSetAlertTime(comps)
                }
            )
        }
    }
}

// MARK: - Local components

private struct SettingsGroup<Content: View>: View {
    let header: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            SectionLabel(header)
                .padding(.horizontal, 4)
            VStack(spacing: 0) { content() }
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.card).fill(CotdColor.card)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.card).stroke(CotdColor.line, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.card))
        }
    }
}

private struct SettingsRow<Trailing: View>: View {
    let label: String
    var sub: String? = nil
    var last: Bool = false
    @ViewBuilder let trailing: () -> Trailing

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(CotdFont.settingRow)
                    .foregroundStyle(CotdColor.ink)
                if let sub {
                    Text(sub)
                        .font(CotdFont.captionSmall)
                        .foregroundStyle(CotdColor.inkMute)
                }
            }
            Spacer()
            trailing()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
    }
}

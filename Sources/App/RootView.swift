import SwiftUI

/// App root — delegates to TabHost which owns navigation + Reveal overlay.
struct RootView: View {
    var body: some View {
        TabHost()
    }
}

#Preview {
    RootView()
}

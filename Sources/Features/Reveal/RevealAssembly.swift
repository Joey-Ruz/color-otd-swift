import SwiftUI

extension Reveal {
    enum Assembly {
        @MainActor
        static func build(
            colorRepo: ColorRepository = MemoryColorRepository(),
            router: Router? = nil
        ) -> Reveal.Scene {
            let useCase = Reveal.UseCase(colorRepo: colorRepo)
            let presenter = Reveal.Presenter(useCase: useCase, router: router)
            return Reveal.Scene(presenter: presenter)
        }
    }
}

#Preview {
    Reveal.Assembly.build()
}

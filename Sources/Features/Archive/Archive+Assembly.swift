import SwiftUI

extension Archive {
    enum Assembly {
        @MainActor
        static func build(
            colorRepo: ColorRepository = MemoryColorRepository(),
            router: Router? = nil
        ) -> Archive.Scene {
            let useCase = Archive.UseCase(colorRepo: colorRepo)
            let presenter = Archive.Presenter(useCase: useCase, router: router)
            return Archive.Scene(presenter: presenter)
        }
    }
}

#Preview {
    Archive.Assembly.build()
}

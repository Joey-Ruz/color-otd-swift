import SwiftUI

extension Search {
    enum Assembly {
        @MainActor
        static func build(
            colorRepo: ColorRepository = MemoryColorRepository(),
            router: Router? = nil
        ) -> Search.Scene {
            let useCase = Search.UseCase(colorRepo: colorRepo)
            let presenter = Search.Presenter(useCase: useCase, router: router)
            return Search.Scene(presenter: presenter)
        }
    }
}

#Preview {
    Search.Assembly.build()
}

import SwiftUI

@main
struct TravelGuideApp: App {

    @StateObject var model: Model

    init() {
        _model = StateObject(wrappedValue: Model())
    }

    var body: some Scene {
        WindowGroup {
            MainView(model: model)
        }
    }
}

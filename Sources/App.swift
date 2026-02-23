import SwiftUI

@main
struct app1App: App {
    @State private var store = EventStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}

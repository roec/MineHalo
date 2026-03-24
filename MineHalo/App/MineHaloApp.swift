import SwiftUI

@main
struct MineHaloApp: App {
    @StateObject private var container = AppContainer.bootstrap()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container.sessionStore)
                .environmentObject(container.router)
                .environmentObject(container.downloadManager)
                .environmentObject(container.theme)
                .environment(\.appContainer, container)
        }
    }
}

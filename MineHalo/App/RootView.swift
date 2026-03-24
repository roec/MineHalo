import SwiftUI

struct RootView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        Group {
            switch router.phase {
            case .splash:
                SplashView()
            case .unauthenticated:
                AuthEntryView()
            case .authenticated:
                MainTabView()
            }
        }
        .task {
            await sessionStore.restoreSessionIfNeeded()
            router.refresh()
        }
        .onChange(of: sessionStore.isAuthenticated) { _, _ in
            router.refresh()
        }
    }
}

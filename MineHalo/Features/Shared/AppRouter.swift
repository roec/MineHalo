import Foundation

@MainActor
final class AppRouter: ObservableObject {
    enum Phase {
        case splash
        case unauthenticated
        case authenticated
    }

    @Published private(set) var phase: Phase = .splash
    private unowned let sessionStore: SessionStore

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }

    func refresh() {
        if sessionStore.isRestoring {
            phase = .splash
        } else {
            phase = sessionStore.isAuthenticated ? .authenticated : .unauthenticated
        }
    }
}

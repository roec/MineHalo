import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var username: String = ""

    private let sessionStore: SessionStore

    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
        refresh()
    }

    func refresh() {
        nickname = sessionStore.user?.nickname ?? "同学"
        username = sessionStore.user?.username ?? "-"
    }

    func logout() {
        sessionStore.logout()
    }
}

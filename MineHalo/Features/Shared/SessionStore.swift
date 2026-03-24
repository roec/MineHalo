import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var token: String?
    @Published var isRestoring = true

    private let authRepository: AuthRepositoryProtocol
    private let keychain: KeychainStoreProtocol
    private let preferences: UserPreferencesProtocol

    init(authRepository: AuthRepositoryProtocol,
         keychain: KeychainStoreProtocol,
         preferences: UserPreferencesProtocol) {
        self.authRepository = authRepository
        self.keychain = keychain
        self.preferences = preferences
    }

    var isAuthenticated: Bool { token?.isEmpty == false && user != nil }

    func restoreSessionIfNeeded() async {
        if !isRestoring { return }
        defer { isRestoring = false }
        token = keychain.read(key: .authToken)
        user = preferences.cachedUser
    }

    func login(username: String, password: String) async throws {
        let result = try await authRepository.login(username: username, password: password)
        try keychain.save(value: result.token, key: .authToken)
        preferences.cachedUser = result.user
        self.token = result.token
        self.user = result.user
    }

    func logout() {
        try? keychain.delete(key: .authToken)
        preferences.cachedUser = nil
        token = nil
        user = nil
    }
}

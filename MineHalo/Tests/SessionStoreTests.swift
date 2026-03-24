import XCTest
@testable import MineHalo

final class SessionStoreTests: XCTestCase {
    func test_restore_without_token_is_not_authenticated() async {
        let keychain = MockKeychain()
        let prefs = MockPrefs()
        let store = await SessionStore(authRepository: MockAuthRepository(), keychain: keychain, preferences: prefs)
        await store.restoreSessionIfNeeded()
        let authed = await store.isAuthenticated
        XCTAssertFalse(authed)
    }
}

private final class MockKeychain: KeychainStoreProtocol {
    var value: String?
    func save(value: String, key: KeychainKey) throws { self.value = value }
    func read(key: KeychainKey) -> String? { value }
    func delete(key: KeychainKey) throws { value = nil }
}

private final class MockPrefs: UserPreferencesProtocol {
    var cachedUser: User?
}

private struct MockAuthRepository: AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> LoginResponse { fatalError() }
    func register(username: String, password: String, nickname: String, mailbox: String, captcha: String) async throws -> AddUserResponse { fatalError() }
    func getCaptcha(mailbox: String) async throws -> CaptchaResponse { fatalError() }
}

import Foundation

protocol AuthRepositoryProtocol {
    func login(username: String, password: String) async throws -> LoginResponse
    func register(username: String, password: String, nickname: String, mailbox: String, captcha: String) async throws -> AddUserResponse
    func getCaptcha(mailbox: String) async throws -> CaptchaResponse
}

final class AuthRepository: AuthRepositoryProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        try await apiClient.send(.login, body: LoginRequest(username: username, password: password))
    }

    func register(username: String, password: String, nickname: String, mailbox: String, captcha: String) async throws -> AddUserResponse {
        try await apiClient.send(.addUser, body: RegisterRequest(username: username, password: password, nickname: nickname, mailbox: mailbox, captcha: captcha))
    }

    func getCaptcha(mailbox: String) async throws -> CaptchaResponse {
        try await apiClient.send(.getCaptcha, body: CaptchaRequest(mailbox: mailbox))
    }
}

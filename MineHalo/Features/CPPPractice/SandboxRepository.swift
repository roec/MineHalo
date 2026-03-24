import Foundation

protocol SandboxRepositoryProtocol {
    func runCode(code: String, userId: String, stdin: String) async throws -> CppAPIResponse
}

final class SandboxRepository: SandboxRepositoryProtocol {
    private let apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) { self.apiClient = apiClient }

    func runCode(code: String, userId: String, stdin: String) async throws -> CppAPIResponse {
        let req = RunCodeRequest(code: code, userId: userId, stdin: stdin)
        return try await apiClient.send(.runSandbox, body: req)
    }
}

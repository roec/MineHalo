import Foundation

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var nickname = ""
    @Published var mailbox = ""
    @Published var captcha = ""
    @Published var message: String?
    @Published var isLoading = false

    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    func fetchCaptcha() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await authRepository.getCaptcha(mailbox: mailbox)
            message = response.captcha.map { "验证码：\($0)" } ?? response.message
        } catch {
            message = error.localizedDescription
        }
    }

    func register() async {
        guard !username.isEmpty, !password.isEmpty, !nickname.isEmpty, !mailbox.isEmpty, !captcha.isEmpty else {
            message = "请完整填写注册信息"
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let resp = try await authRepository.register(username: username, password: password, nickname: nickname, mailbox: mailbox, captcha: captcha)
            message = resp.message
        } catch {
            message = error.localizedDescription
        }
    }
}

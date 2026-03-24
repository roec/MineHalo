import SwiftUI

struct RegisterView: View {
    @Environment(\.appContainer) private var container
    @StateObject private var vmHolder = Holder()

    final class Holder: ObservableObject { @Published var vm: RegisterViewModel? }

    var body: some View {
        let vm = bindVM()
        Form {
            Section("注册账号") {
                TextField("用户名", text: vm.username)
                SecureField("密码", text: vm.password)
                TextField("昵称", text: vm.nickname)
                TextField("邮箱", text: vm.mailbox)
                    .textInputAutocapitalization(.never)
                HStack {
                    TextField("验证码", text: vm.captcha)
                    Button("获取验证码") { Task { await vm.fetchCaptcha() } }
                }
            }

            Section {
                PrimaryButton(title: "注册", loading: vm.isLoading) { Task { await vm.register() } }
            }

            if let message = vm.message {
                Section { Text(message).foregroundStyle(.secondary) }
            }
        }
        .navigationTitle("注册")
    }

    private func bindVM() -> RegisterBridge {
        if vmHolder.vm == nil { vmHolder.vm = RegisterViewModel(authRepository: container.authRepository) }
        guard let vm = vmHolder.vm else {
            let fallback = RegisterViewModel(authRepository: container.authRepository)
            vmHolder.vm = fallback
            return RegisterBridge(vm: fallback)
        }
        return RegisterBridge(vm: vm)
    }
}

private struct RegisterBridge {
    let vm: RegisterViewModel
    var username: Binding<String> { Binding(get: { vm.username }, set: { vm.username = $0 }) }
    var password: Binding<String> { Binding(get: { vm.password }, set: { vm.password = $0 }) }
    var nickname: Binding<String> { Binding(get: { vm.nickname }, set: { vm.nickname = $0 }) }
    var mailbox: Binding<String> { Binding(get: { vm.mailbox }, set: { vm.mailbox = $0 }) }
    var captcha: Binding<String> { Binding(get: { vm.captcha }, set: { vm.captcha = $0 }) }
    var isLoading: Bool { vm.isLoading }
    var message: String? { vm.message }
    func fetchCaptcha() async { await vm.fetchCaptcha() }
    func register() async { await vm.register() }
}

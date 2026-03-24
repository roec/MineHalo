import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var vmHolder = Holder()

    final class Holder: ObservableObject { @Published var vm: LoginViewModel? }

    var body: some View {
        let vm = bindVM()
        VStack(spacing: 16) {
            Text("欢迎来到 MineHalo")
                .font(.title2.bold())
            TextField("用户名", text: vm.usernameBinding)
                .textFieldStyle(.roundedBorder)
            Group {
                if vm.showPassword {
                    TextField("密码", text: vm.passwordBinding)
                } else {
                    SecureField("密码", text: vm.passwordBinding)
                }
            }
            .textFieldStyle(.roundedBorder)
            Toggle("显示密码", isOn: vm.showPasswordBinding)
            if let msg = vm.errorMessage {
                Text(msg).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading)
            }
            PrimaryButton(title: "登录", loading: vm.isLoading) {
                Task { await vm.login() }
            }
            NavigationLink("去注册", destination: RegisterView())
            Spacer()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
    }

    private func bindVM() -> LoginViewModelBridge {
        if vmHolder.vm == nil { vmHolder.vm = LoginViewModel(sessionStore: sessionStore) }
        guard let vm = vmHolder.vm else {
            let fallback = LoginViewModel(sessionStore: sessionStore)
            vmHolder.vm = fallback
            return LoginViewModelBridge(vm: fallback)
        }
        return LoginViewModelBridge(vm: vm)
    }
}

private struct LoginViewModelBridge {
    let vm: LoginViewModel
    var usernameBinding: Binding<String> { Binding(get: { vm.username }, set: { vm.username = $0 }) }
    var passwordBinding: Binding<String> { Binding(get: { vm.password }, set: { vm.password = $0 }) }
    var showPasswordBinding: Binding<Bool> { Binding(get: { vm.showPassword }, set: { vm.showPassword = $0 }) }
    var showPassword: Bool { vm.showPassword }
    var isLoading: Bool { vm.isLoading }
    var errorMessage: String? { vm.errorMessage }
    func login() async { await vm.login() }
}

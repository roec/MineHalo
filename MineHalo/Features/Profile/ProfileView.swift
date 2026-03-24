import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @StateObject private var holder = Holder()

    final class Holder: ObservableObject { @Published var vm: ProfileViewModel? }

    var body: some View {
        let vm = bindVM()
        List {
            Section("个人信息") {
                Text("昵称：\(vm.nickname)")
                Text("账号：\(vm.username)")
            }

            Section("学习成长") {
                NavigationLink("成长报告") { GrowthReportView() }
                NavigationLink("我的奖章") { Text("奖章系统建设中") }
            }

            Section {
                Button("退出登录", role: .destructive) { vm.logout() }
            }
        }
        .navigationTitle("我的")
    }

    private func bindVM() -> ProfileViewModel {
        if holder.vm == nil { holder.vm = ProfileViewModel(sessionStore: sessionStore) }
        guard let vm = holder.vm else {
            let fallback = ProfileViewModel(sessionStore: sessionStore)
            holder.vm = fallback
            return fallback
        }
        return vm
    }
}

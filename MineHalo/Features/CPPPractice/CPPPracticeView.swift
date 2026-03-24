import SwiftUI

struct CPPPracticeView: View {
    let courseId: String
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.appContainer) private var container
    @StateObject private var holder = Holder()
    @State private var showHint = false

    final class Holder: ObservableObject { @Published var vm: CPPPracticeViewModel? }

    var body: some View {
        let vm = bindVM()
        VStack(spacing: 12) {
            if let exam = vm.currentExam {
                HStack {
                    Text("第\(exam.index)题 / \(vm.exams.count)题")
                    Spacer()
                    Text("难度：\(exam.level)")
                }
                .font(.subheadline)

                Text(exam.question).frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: Binding(get: { vm.code }, set: { vm.code = $0 }))
                    .frame(height: 180)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray.opacity(0.3)))
                TextField("输入(stdin)", text: Binding(get: { vm.stdin }, set: { vm.stdin = $0 }))
                    .textFieldStyle(.roundedBorder)

                VStack(alignment: .leading) {
                    Text("输出")
                    ScrollView { Text(vm.stdout).frame(maxWidth: .infinity, alignment: .leading) }
                        .frame(height: 80)
                        .padding(8)
                        .background(.green.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text("错误")
                    ScrollView { Text(vm.error).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading) }
                        .frame(height: 80)
                        .padding(8)
                        .background(.red.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                HStack {
                    Button("上一题") { vm.prev() }
                    Button("提示") { showHint.toggle() }
                    Spacer()
                    Button("运行") { Task { await vm.run() } }
                    Button("保存") { Task { await vm.save() } }
                    Button("下一题") { vm.next() }
                }
                .buttonStyle(.bordered)
            } else {
                ContentUnavailableView("暂无编程练习", systemImage: "terminal")
            }
        }
        .padding()
        .navigationTitle("C++ 练习")
        .task { await vm.load(courseId: courseId) }
        .sheet(isPresented: $showHint) {
            VStack(alignment: .leading, spacing: 12) {
                Text("提示")
                    .font(.headline)
                Text(vm.currentExam?.hintMessage ?? "暂无提示")
                Spacer()
            }
            .padding()
        }
        .loading(vm.isLoading)
    }

    private func bindVM() -> CPPPracticeViewModel {
        if holder.vm == nil {
            holder.vm = CPPPracticeViewModel(session: sessionStore,
                                             practiceRepository: container.practiceRepository,
                                             sandboxRepository: container.sandboxRepository)
        }
        guard let vm = holder.vm else {
            let fallback = CPPPracticeViewModel(session: sessionStore,
                                                practiceRepository: container.practiceRepository,
                                                sandboxRepository: container.sandboxRepository)
            holder.vm = fallback
            return fallback
        }
        return vm
    }
}

import SwiftUI

struct QuizView: View {
    let category: CourseCategory
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.appContainer) private var container
    @StateObject private var holder = Holder()
    @Environment(\.dismiss) private var dismiss
    @State private var showExitConfirm = false

    final class Holder: ObservableObject { @Published var vm: QuizViewModel? }

    var body: some View {
        let vm = bindVM()
        VStack(spacing: 16) {
            if let question = vm.questions[safe: vm.index] {
                Text(question.question)
                    .font(.title3.bold())
                ForEach(vm.currentChoices) { choice in
                    Button("\(choice.key). \(choice.value)") { vm.choose(choice) }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.blue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                if vm.showHint {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("提示")
                            .font(.headline)
                        Text(question.hintMessage)
                        Button("继续下一题") { vm.goNext() }
                    }
                    .cardStyle()
                }
            } else {
                ContentUnavailableView("暂无题目", systemImage: "questionmark.circle")
            }
            if let feedback = vm.feedback { Text(feedback).foregroundStyle(.secondary) }
            Spacer()
        }
        .padding()
        .navigationTitle("\(category.title) 练习")
        .task { await vm.load(category: category) }
        .overlay {
            if vm.isCompleted {
                VStack(spacing: 12) {
                    Text("恭喜完成本次练习！").font(.title3.bold())
                    Button("返回") { dismiss() }
                }
                .padding(24)
                .background(.ultraThickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("退出") { showExitConfirm = true }
            }
        }
        .alert("练习未完成，确定退出？", isPresented: $showExitConfirm) {
            Button("继续练习", role: .cancel) {}
            Button("退出", role: .destructive) { dismiss() }
        }
    }

    private func bindVM() -> QuizViewModel {
        if holder.vm == nil {
            holder.vm = QuizViewModel(session: sessionStore, repository: container.practiceRepository)
        }
        guard let vm = holder.vm else {
            let fallback = QuizViewModel(session: sessionStore, repository: container.practiceRepository)
            holder.vm = fallback
            return fallback
        }
        return vm
    }
}

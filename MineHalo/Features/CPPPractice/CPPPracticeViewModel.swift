import Foundation

@MainActor
final class CPPPracticeViewModel: ObservableObject {
    @Published var exams: [ExamListModel] = []
    @Published var index = 0
    @Published var code = ""
    @Published var stdin = ""
    @Published var stdout = ""
    @Published var error = ""
    @Published var isLoading = false

    private let session: SessionStore
    private let practiceRepository: PracticeRepositoryProtocol
    private let sandboxRepository: SandboxRepositoryProtocol

    init(session: SessionStore,
         practiceRepository: PracticeRepositoryProtocol,
         sandboxRepository: SandboxRepositoryProtocol) {
        self.session = session
        self.practiceRepository = practiceRepository
        self.sandboxRepository = sandboxRepository
    }

    var currentExam: ExamListModel? { exams[safe: index] }

    func load(courseId: String) async {
        guard let uid = session.user?.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            exams = try await practiceRepository.fetchExamList(userId: uid, courseId: courseId)
            fillFields()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func run() async {
        guard let uid = session.user?.id else { return }
        do {
            let result = try await sandboxRepository.runCode(code: code, userId: uid, stdin: stdin)
            stdout = result.output
            error = result.error
        } catch {
            self.error = error.localizedDescription
        }
    }

    func save() async {
        guard let exam = currentExam else { return }
        _ = try? await practiceRepository.updateExam(examId: exam.id, payload: ["code": code, "stdin": stdin, "stdout": stdout, "error": error])
    }

    func prev() { if index > 0 { index -= 1; fillFields() } }
    func next() { if index + 1 < exams.count { index += 1; fillFields() } }

    private func fillFields() {
        guard let exam = currentExam else { return }
        code = exam.code
        stdin = exam.stdin
        stdout = exam.stdout
        error = exam.error
    }
}

import Foundation

@MainActor
final class QuizViewModel: ObservableObject {
    @Published var questions: [QuestionDetail] = []
    @Published var index = 0
    @Published var currentChoices: [QuizChoice] = []
    @Published var showHint = false
    @Published var isCompleted = false
    @Published var feedback: String?
    @Published var isLoading = false

    private let session: SessionStore
    private let repository: PracticeRepositoryProtocol
    private var hasMistakeOnCurrent = false

    init(session: SessionStore, repository: PracticeRepositoryProtocol) {
        self.session = session
        self.repository = repository
    }

    func load(category: CourseCategory) async {
        guard let uid = session.user?.id else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let list = try await repository.fetchQuestionList(userId: uid, category: category)
            questions = try await repository.fetchQuestions(ids: list.map(\.questionId))
            reshuffle()
        } catch {
            feedback = error.localizedDescription
        }
    }

    func choose(_ choice: QuizChoice) {
        guard let question = questions[safe: index] else { return }
        if choice.key == question.answer {
            AudioManager.shared.play(effect: "right")
            feedback = "回答正确！"
            if hasMistakeOnCurrent {
                showHint = true
            } else {
                goNext()
            }
        } else {
            hasMistakeOnCurrent = true
            AudioManager.shared.play(effect: "wrong")
            feedback = "回答错误，再试试"
            reshuffle()
        }
    }

    func goNext() {
        showHint = false
        hasMistakeOnCurrent = false
        if index + 1 >= questions.count {
            isCompleted = true
        } else {
            index += 1
            reshuffle()
        }
    }

    func reshuffle() {
        currentChoices = questions[safe: index]?.choices.shuffled() ?? []
    }
}

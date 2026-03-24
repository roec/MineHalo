import Foundation

protocol PracticeRepositoryProtocol {
    func fetchQuestionList(userId: String, category: CourseCategory) async throws -> [QuestionListItem]
    func fetchQuestions(ids: [String]) async throws -> [QuestionDetail]
    func fetchExamList(userId: String, courseId: String) async throws -> [ExamListModel]
    func updateExam(examId: String, payload: [String: String]) async throws -> ExamListModel
}

final class PracticeRepository: PracticeRepositoryProtocol {
    private let apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) { self.apiClient = apiClient }

    func fetchQuestionList(userId: String, category: CourseCategory) async throws -> [QuestionListItem] {
        let req = QuestionListRequest(userId: userId, courseCategory: category.rawValue)
        let response: QuestionListResponse = try await apiClient.send(.userQuestionList, body: req)
        return response.questionList
    }

    func fetchQuestions(ids: [String]) async throws -> [QuestionDetail] {
        let response: QuestionsResponse = try await apiClient.send(.questions, body: QuestionsRequest(questionIds: ids))
        return response.questions
    }

    func fetchExamList(userId: String, courseId: String) async throws -> [ExamListModel] {
        let response: ExamListResponse = try await apiClient.send(.examList, body: ExamListRequest(userId: userId, courseId: courseId))
        return response.examList.sorted { $0.index < $1.index }
    }

    func updateExam(examId: String, payload: [String : String]) async throws -> ExamListModel {
        try await apiClient.send(.updateExam(examId: examId), body: payload)
    }
}

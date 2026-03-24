import Foundation

struct ExamListModel: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let courseId: String
    let quizId: String?
    let question: String
    let hintMessage: String
    let index: Int
    let level: String
    var stdin: String
    var code: String
    var stdout: String
    var error: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId, courseId, quizId, question, hintMessage, index, level, stdin, code, stdout, error, createdAt, updatedAt
    }
}

struct ExamListResponse: Codable {
    let examList: [ExamListModel]

    enum CodingKeys: String, CodingKey {
        case examList = "ExamList"
    }
}

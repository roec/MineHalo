import Foundation

struct QuestionListItem: Codable, Identifiable {
    var id: String { questionId }
    let userId: String
    let questionId: String
    let courseCategory: String
}

struct QuestionListResponse: Codable {
    let questionList: [QuestionListItem]

    enum CodingKeys: String, CodingKey {
        case questionList = "QuestionList"
    }
}

struct QuestionDetail: Codable, Identifiable {
    let id: String
    let question: String
    let choices: [QuizChoice]
    let answer: String
    let hintMessage: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, choices, answer, hintMessage
    }
}

struct QuestionsResponse: Codable {
    let questions: [QuestionDetail]
}

struct QuizChoice: Codable, Hashable, Identifiable {
    var id: String { value }
    let key: String
    let value: String
}

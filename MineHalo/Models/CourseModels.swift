import Foundation

enum CourseCategory: String, Codable, CaseIterable, Identifiable {
    case cpp = "cpp"
    case python = "python"
    case ai = "ai"
    case topic = "topic"

    var id: String { rawValue }
    var title: String {
        switch self {
        case .cpp: return "C++"
        case .python: return "Python"
        case .ai: return "AI"
        case .topic: return "专题"
        }
    }
}

struct CourseListModel: Codable, Identifiable, Hashable {
    var id: String { courseId }
    let userId: String
    let courseId: String
    let courseNo: String
    let courseName: String
    let directoryPath: String
    let hasExams: Bool
    let isLocked: Bool
    var isDownloaded: Bool
    let isStudied: Bool
    let isCompleted: Bool
    let createdAt: String?
    let updatedAt: String?
}

struct CourseListResponse: Codable {
    let courseList: [CourseListModel]

    enum CodingKeys: String, CodingKey {
        case courseList = "CourseList"
    }
}

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIEndpoint {
    case login
    case addUser
    case getCaptcha
    case userCourseList
    case updateCourseStatus(userId: String, courseId: String)
    case downloadCourseZip(courseId: String, courseName: String)
    case runSandbox
    case examList
    case updateExam(examId: String)
    case userQuestionList
    case questions

    var path: String {
        switch self {
        case .login: return "/api/users/login"
        case .addUser: return "/api/users/addUser"
        case .getCaptcha: return "/api/users/getCaptcha"
        case .userCourseList: return "/api/course/getUserCourseList"
        case .updateCourseStatus(let userId, let courseId): return "/api/course/putCourseStatus/\(userId)/\(courseId)"
        case .downloadCourseZip(let courseId, let courseName): return "/api/course/download/\(courseId)?courseName=\(courseName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? courseName)"
        case .runSandbox: return "/api/sandbox/run"
        case .examList: return "/api/exam/getExameList"
        case .updateExam(let examId): return "/api/exam/putExam/\(examId)"
        case .userQuestionList: return "/api/question/getUserQuestionList"
        case .questions: return "/api/question/getQuestions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .updateCourseStatus, .updateExam:
            return .put
        case .login, .addUser, .getCaptcha, .userCourseList, .runSandbox, .examList, .userQuestionList, .questions:
            return .post
        case .downloadCourseZip:
            return .get
        }
    }
}

import Foundation

struct LoginRequest: Codable { let username: String; let password: String }
struct RegisterRequest: Codable { let username: String; let password: String; let nickname: String; let mailbox: String; let captcha: String }
struct CaptchaRequest: Codable { let mailbox: String }
struct CourseListRequest: Codable { let userId: String; let courseCategory: String }
struct UpdateCourseStatusRequest: Codable { let isLocked: Bool?; let isDownloaded: Bool?; let isStudied: Bool?; let isCompleted: Bool? }
struct RunCodeRequest: Codable { let code: String; let userId: String; let stdin: String }
struct ExamListRequest: Codable { let userId: String; let courseId: String }
struct QuestionListRequest: Codable { let userId: String; let courseCategory: String }
struct QuestionsRequest: Codable { let questionIds: [String] }

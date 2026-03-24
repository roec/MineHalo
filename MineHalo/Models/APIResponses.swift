import Foundation

struct APIResponse: Codable {
    let message: String?
}

struct LoginResponse: Codable {
    let user: User
    let token: String
}

struct AddUserResponse: Codable {
    let message: String
}

struct CaptchaResponse: Codable {
    let message: String
    let phone: String?
    let captcha: String?
}

struct CppAPIResponse: Codable {
    let output: String
    let error: String
}

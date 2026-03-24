import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: String
    let username: String
    let password: String?
    let nickname: String
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username, password, nickname, createdAt, updatedAt
    }
}

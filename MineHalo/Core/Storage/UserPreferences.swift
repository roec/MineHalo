import Foundation

protocol UserPreferencesProtocol {
    var cachedUser: User? { get set }
}

final class UserPreferences: UserPreferencesProtocol {
    private let userKey = "minehalo.cached.user"

    var cachedUser: User? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let newValue,
               let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }
}

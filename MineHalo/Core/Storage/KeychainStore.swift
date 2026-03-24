import Foundation
import Security

enum KeychainKey: String { case authToken }

protocol KeychainStoreProtocol {
    func save(value: String, key: KeychainKey) throws
    func read(key: KeychainKey) -> String?
    func delete(key: KeychainKey) throws
}

final class KeychainStore: KeychainStoreProtocol {
    func save(value: String, key: KeychainKey) throws {
        let data = Data(value.utf8)
        try? delete(key: key)
        let status = SecItemAdd([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ] as CFDictionary, nil)
        guard status == errSecSuccess else { throw APIError.unknown }
    }

    func read(key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }

    func delete(key: KeychainKey) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ] as CFDictionary
        SecItemDelete(query)
    }
}

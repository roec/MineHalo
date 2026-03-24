import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case transport(Error)
    case server(statusCode: Int, message: String)
    case decoding(Error)
    case encoding(Error)
    case unauthorized
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的请求地址"
        case .transport(let error): return error.localizedDescription
        case .server(_, let message): return message
        case .decoding: return "数据解析失败"
        case .encoding: return "请求编码失败"
        case .unauthorized: return "登录已失效，请重新登录"
        case .unknown: return "未知错误"
        }
    }
}

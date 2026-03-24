import Foundation

protocol APIClientProtocol {
    func send<T: Decodable, U: Encodable>(_ endpoint: APIEndpoint, body: U?) async throws -> T
    func send<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func download(_ endpoint: APIEndpoint) async throws -> URL
}

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let tokenProvider: () -> String?

    init(baseURL: URL,
         session: URLSession = .shared,
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         tokenProvider: @escaping () -> String?) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.tokenProvider = tokenProvider
    }

    func send<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        try await send(endpoint, body: Optional<String>.none)
    }

    func send<T: Decodable, U: Encodable>(_ endpoint: APIEndpoint, body: U?) async throws -> T {
        var request = try buildRequest(for: endpoint)
        if let body {
            do {
                request.httpBody = try encoder.encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw APIError.encoding(error)
            }
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.transport(error)
        }

        try validate(response: response, data: data)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    func download(_ endpoint: APIEndpoint) async throws -> URL {
        let request = try buildRequest(for: endpoint)
        let (url, response) = try await session.download(for: request)
        try validate(response: response, data: Data())
        return url
    }

    private func buildRequest(for endpoint: APIEndpoint) throws -> URLRequest {
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = tokenProvider(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else { throw APIError.unknown }
        guard 200..<300 ~= http.statusCode else {
            if http.statusCode == 401 { throw APIError.unauthorized }
            let message = String(data: data, encoding: .utf8) ?? "服务器错误"
            throw APIError.server(statusCode: http.statusCode, message: message)
        }
    }
}

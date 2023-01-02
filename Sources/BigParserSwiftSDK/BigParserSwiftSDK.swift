import Foundation

public final class BigParser {

    // MARK: - Singleton
    public static let shared = BigParser()

    private init() {

    }

    public var authId: String?

    private struct Constants {
        static let baseURLString: String = "https://qa.BigParser.com/api/v2/"
    }

    private enum HTTPMethod: String {
        case GET, POST, DELETE, PATCH
    }

    // MARK: - Authentication

    public func signUp(_ signUpRequest: SignUpRequest) async throws -> LoginResponse {
        try await request(method: .POST, path: "common/signup", request: signUpRequest)
    }

    public func logIn(_ loginRequest: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse = try await request(method: .POST, path: "common/login", request: loginRequest)

        authId = response.authID
        return response
    }

    public func logOut() {
        authId = nil
    }

    // MARK: - Read operations

    public func searchGrid(_ gridId: String, shareId: String? = nil, searchRequest: SearchRequest) async throws -> LoginResponse {
        if let shareId = shareId {
            return try await request(method: .POST, path: "grid/\(gridId)/share/\(shareId)/search", request: searchRequest)
        } else {
            return try await request(method: .POST, path: "grid/\(gridId)/search", request: searchRequest)
        }
    }


    // MARK: - Write operations

    public func createGrid(_ gridId: String, searchRequest: SearchRequest) async throws -> LoginResponse {
        try await request(method: .POST, path: "grid/\(gridId)/search", request: searchRequest)
    }

    // MARK: - Base request

    private func request<Request: Encodable, Response: Decodable>(method: HTTPMethod, path: String, request: Request) async throws -> Response {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<Response, Error>) in
            let url = URL(string: Constants.baseURLString + path)!
            var urlRequest = URLRequest(url: url)

            do {
                urlRequest.httpBody = try JSONEncoder().encode(request)
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.httpMethod = method.rawValue
            } catch {
                continuation.resume(throwing: error)
                return
            }

            if let authId = authId {
                urlRequest.addValue(authId, forHTTPHeaderField: "authId")
            }

            print("curl:\n\(urlRequest.curlString)")

            URLSession.shared.dataTask(
                with: urlRequest,
                completionHandler: { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        if let data = data {
                            print("\(String(data: data, encoding: .utf8) ?? "")")
                            do {
                                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                                continuation.resume(returning: decodedResponse)
                            } catch {
                                // Try parsing Error
                                do {
                                    let decodedResponse = try JSONDecoder().decode(BigParserErrorResponse.self, from: data)
                                    continuation.resume(throwing: decodedResponse)
                                } catch {
                                    continuation.resume(throwing: error)
                                }
                            }
                        } else {
                            continuation.resume(throwing: BigParserRequestError.emptyResponse)
                        }
                    }
                }).resume()
        })
    }
}

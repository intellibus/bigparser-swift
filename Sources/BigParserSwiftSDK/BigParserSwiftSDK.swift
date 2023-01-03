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

    public func searchGrid(_ gridId: String, shareId: String? = nil, searchRequest: SearchRequest) async throws -> SearchResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: searchRequest)
    }

    public func getGridHeader(_ gridId: String, shareId: String? = nil) async throws -> GetGridHeaderResponse {
        try await request(method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_metadata")
    }

    public func getMultiSheetMetadata(_ gridId: String, shareId: String? = nil) async throws -> GetMultiSheetMetadataResponse {
        try await request(method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_multisheet_metadata")
    }

    // MARK: - Write operations

    public func createGrid(_ gridId: String, searchRequest: SearchRequest) async throws -> LoginResponse {
        try await request(method: .POST, path: "grid/\(gridId)/search", request: searchRequest)
    }

    public func insertRows(_ gridId: String, shareId: String? = nil, insertRowsRequest: InsertRowsRequest) async throws -> InsertRowsResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/create", request: insertRowsRequest)
    }

    public func updateRows(_ gridId: String, shareId: String? = nil, updateRowsRequest: UpdateRowsRequest) async throws -> UpdateRowsResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_rowIds", request: updateRowsRequest)
    }

    public func updateRows(_ gridId: String, shareId: String? = nil, updateRowsByQueryRequest: UpdateRowsByQueryRequest) async throws -> UpdateRowsByQueryResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_queryObj", request: updateRowsByQueryRequest)
    }

    // MARK: - Delete operations

    public func deleteRows(_ gridId: String, shareId: String? = nil, deleteRows: DeleteRowsRequest) async throws -> DeleteRowsResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_rowIds", request: deleteRows)
    }

    public func deleteRows(_ gridId: String, shareId: String? = nil, deleteRowsByQueryRequest: DeleteRowsByQueryRequest) async throws -> DeleteRowsByQueryResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_queryObj", request: deleteRowsByQueryRequest)
    }

    // MARK: - Convenience

    private func gridPath(_ gridId: String, shareId: String? = nil) -> String {
        if let shareId = shareId {
            return "grid/\(gridId)/share/\(shareId)"
        } else {
            return "grid/\(gridId)"
        }
    }

    private func request<Response: Decodable>(method: HTTPMethod, path: String) async throws -> Response {
        try await request(method: method, path: path, request: false)
    }

    private func request<Request: Encodable, Response: Decodable>(method: HTTPMethod, path: String, request: Request) async throws -> Response {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<Response, Error>) in
            let url = URL(string: Constants.baseURLString + path)!
            var urlRequest = URLRequest(url: url)

            if request is Bool == false {
                do {
                    urlRequest.httpBody = try JSONEncoder().encode(request)
                    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }
            urlRequest.httpMethod = method.rawValue

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
                                print(error)
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

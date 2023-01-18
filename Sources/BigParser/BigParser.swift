import Foundation

public final class BigParser {

    // MARK: - Singleton
    public static let shared = BigParser()

    private init() {

    }

    public var authId: String?

    // MARK: - Type Definitions

    private struct Constants {
        static let authBaseURLString: String = "https://qa.bigparser.com/APIServices/api/"
        static let apiBaseURLString: String = "https://qa.BigParser.com/api/v2/"
        static let websocketURLString: String = "https://qa.bigparser.com/websocket-server/chat"
//        static let websocketURLString: String = "wss://qa.bigparser.com/websocket-server/chat/022/jaz5bvqr/websocket"
    }

    private enum HTTPMethod: String {
        case GET, PUT, POST, DELETE, PATCH
    }

    // MARK: - Authentication

    @discardableResult
    public func signUp(_ signUpRequest: SignUpRequest) async throws -> SignUpResponse {
        try await request(baseURLString: Constants.authBaseURLString, method: .POST, path: "common/signup", request: signUpRequest)
    }

    @discardableResult
    public func logIn(_ loginRequest: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse = try await request(baseURLString: Constants.authBaseURLString, method: .POST, path: "common/login", request: loginRequest)

        authId = response.authId
        return response
    }

    public func logOut() {
        authId = nil
    }

    // MARK: - Read operations

    public func searchGrid(_ gridId: String, shareId: String? = nil, searchRequest: SearchRequest) async throws -> SearchResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: searchRequest)
    }

    public func searchGridWithColumnNames(_ gridId: String, shareId: String? = nil, searchRequest: SearchRequest) async throws -> SearchResponseWithColumnNames {
        var updatedSearchRequest = searchRequest
        updatedSearchRequest.query.showColumnNamesInResponse = true

        return try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: updatedSearchRequest)
    }

    public func getGridHeader(_ gridId: String, shareId: String? = nil) async throws -> GetGridHeaderResponse {
        try await request(method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_metadata")
    }

    public func getMultiSheetMetadata(_ gridId: String, shareId: String? = nil) async throws -> GetMultiSheetMetadataResponse {
        try await request(method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_multisheet_metadata")
    }

    public func getSearchCount(_ gridId: String, shareId: String? = nil, searchCountRequest: SearchCountRequest) async throws -> SearchCountResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_count", request: searchCountRequest)
    }

    public func getSearchKeywordsCount(_ gridId: String, shareId: String? = nil, searchKeywordsCountRequest: SearchKeywordsCountRequest) async throws -> SearchKeywordsCountResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_keywords_count", request: searchKeywordsCountRequest)
    }

    // MARK: - Write operations

    @discardableResult
    public func insertRows(_ gridId: String, shareId: String? = nil, insertRowsRequest: InsertRowsRequest) async throws -> InsertRowsResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/create", request: insertRowsRequest)
    }

    @discardableResult
    public func updateOrInsertRows(_ gridId: String, shareId: String? = nil, updateRowsRequest: UpdateRowsRequest) async throws -> UpdateRowsResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_rowIds", request: updateRowsRequest)
    }

    @discardableResult
    public func updateRows(_ gridId: String, shareId: String? = nil, updateRowsByQueryRequest: UpdateRowsByQueryRequest) async throws -> UpdateRowsByQueryResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_queryObj", request: updateRowsByQueryRequest)
    }

    @discardableResult
    public func updateColumnDataType(_ gridId: String, shareId: String? = nil, updateColumnDataTypeRequest: UpdateColumnDataTypeRequest) async throws -> UpdateColumnDataTypeResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/update_column_datatype", request: updateColumnDataTypeRequest)
    }

    @discardableResult
    public func addColumn(_ gridId: String, addColumnRequest: AddColumnRequest) async throws -> AddColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/add_column", request: addColumnRequest)
    }

    @discardableResult
    public func addColumns(_ gridId: String, addColumnsRequest: AddColumnsRequest) async throws -> [AddColumnsResponse] {
        try await request(method: .POST, path: "grid/\(gridId)/add_columns", request: addColumnsRequest)
    }

//    add_column

    // MARK: - Delete operations

    @discardableResult
    public func deleteRows(_ gridId: String, shareId: String? = nil, deleteRows: DeleteRowsRequest) async throws -> DeleteRowsResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_rowIds", request: deleteRows)
    }

    @discardableResult
    public func deleteRows(_ gridId: String, shareId: String? = nil, deleteRowsByQueryRequest: DeleteRowsByQueryRequest) async throws -> DeleteRowsByQueryResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_queryObj", request: deleteRowsByQueryRequest)
    }

    @discardableResult
    public func removeColumns(_ gridId: String, shareId: String? = nil, removeColumnsRequest: RemoveColumnsRequest) async throws -> RemoveColumnsResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/remove_columns", request: removeColumnsRequest)
    }

    // MARK: - WebSocket
    private lazy var stream: WebSocketStream? = {
        guard let authId = self.authId else {
            return nil
        }
        return WebSocketStream(
            url: URL(string: Constants.websocketURLString)!,
            headers: ["Sec-WebSocket-Key": "Z806tr6pbH2UTgPsiq17wg==",
                      "authId": authId])
    }()

    // TODO: we have to define the grid as part of the URL...
    // var topicToUsed  = "/topic/grid/63c41c96cb59062e0214a28e/share_edit"
    // var topicToUsed  = "/topic/user/<userid>/grid_updates"  /topic/user/63b30243ce8ca14bd7f81ed6/grid_updates
    func webSocketStream(gridId: String) -> WebSocketStream {
        stream!
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

    private func request<Request: Encodable, Response: Decodable>(baseURLString: String = Constants.apiBaseURLString, method: HTTPMethod, path: String, request: Request) async throws -> Response {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<Response, Error>) in
            let url = URL(string: baseURLString + path)!
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
            unit_test_print("curl:\n\(urlRequest.curlString)")

            URLSession.shared.dataTask(
                with: urlRequest,
                completionHandler: { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        if var data = data {
                            // Replacing empty response with valid JSON
                            if (data as NSData).length == 0 {
                                if Response.self is AnyTypeOfArrayResponse.Type {
                                    data = "[]".data(using: .utf8)!
                                } else {
                                    data = "{}".data(using: .utf8)!
                                }
                            }
                            self.unit_test_print("\(String(data: data, encoding: .utf8) ?? "")")

                            let errorCode = (response as? HTTPURLResponse)?.statusCode ?? 200

                            switch errorCode {
                            case 200...299:
                                do {
                                    let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                                    continuation.resume(returning: decodedResponse)
                                } catch {
                                    continuation.resume(throwing: error)
                                }
                            default:
                                // Try parsing Error
                                do {
                                    let decodedResponse = try JSONDecoder().decode(BigParserErrorResponse.self, from: data)
                                    continuation.resume(throwing: decodedResponse)
                                } catch {
                                    if let dataString = String(data: data, encoding: .utf8),
                                       let knownStringError = BigParserStringResponseError(rawValue: dataString) {
                                        continuation.resume(throwing: knownStringError)
                                    } else {
                                        continuation.resume(throwing: BigParserRequestError.unknownError)
                                    }
                                }
                            }
                        } else {
                            continuation.resume(throwing: BigParserRequestError.emptyResponse)
                        }
                    }
                }).resume()
        })
    }

    // MARK: - Debugging

    private func unit_test_print(_ string: String) {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
             // Code only executes when tests are running
            print(string)
        }
    }
}


protocol AnyTypeOfArrayResponse { }
extension Array: AnyTypeOfArrayResponse { }
extension NSArray: AnyTypeOfArrayResponse { }
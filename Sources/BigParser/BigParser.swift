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
    }

    private enum HTTPMethod: String {
        case GET, PUT, POST, DELETE, PATCH, CONNECT, HEAD, TRACE
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

    public func searchGrid(_ gridId: String, shareId: String? = nil, request searchRequest: SearchRequest) async throws -> SearchResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: searchRequest)
    }

    public func searchGridWithColumnNames(_ gridId: String, shareId: String? = nil, request searchRequest: SearchRequest) async throws -> SearchResponseWithColumnNames {
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

    public func getSearchCount(_ gridId: String, shareId: String? = nil, request searchCountRequest: SearchCountRequest) async throws -> SearchCountResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_count", request: searchCountRequest)
    }

    public func getSearchKeywordsCount(_ gridId: String, shareId: String? = nil, request searchKeywordsCountRequest: SearchKeywordsCountRequest) async throws -> SearchKeywordsCountResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_keywords_count", request: searchKeywordsCountRequest)
    }

    // MARK: - Write operations

    @discardableResult
    public func createGrid(request createGridRequest: CreateGridRequest) async throws -> CreateGridResponse {
        try await request(method: .POST, path: "grid/create_grid", request: createGridRequest)
    }

    /// The gridId represents the id of the grid which should be a parent to the new tab (which is also represented by a grid)
    @discardableResult
    public func createTab(_ gridId: String, request createTabRequest: CreateTabRequest) async throws -> CreateTabResponse {
        try await request(method: .POST, path: "grid/\(gridId)/create_tab", request: createTabRequest)
    }

    /// The gridId represents the id of this tab
    @discardableResult
    public func updateTab(_ gridId: String, request updateTabRequest: UpdateTabRequest) async throws -> UpdateTabResponse {
        try await request(method: .POST, path: "grid/\(gridId)/update_tab", request: updateTabRequest)
    }

    @discardableResult
    public func insertRows(_ gridId: String, shareId: String? = nil, request insertRowsRequest: InsertRowsRequest) async throws -> InsertRowsResponse {
        try await request(method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/create", request: insertRowsRequest)
    }

    @discardableResult
    public func updateOrInsertRows(_ gridId: String, shareId: String? = nil, request updateRowsRequest: UpdateRowsRequest) async throws -> UpdateRowsResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_rowIds", request: updateRowsRequest)
    }

    @discardableResult
    public func updateRows(_ gridId: String, shareId: String? = nil, request updateRowsByQueryRequest: UpdateRowsByQueryRequest) async throws -> UpdateRowsByQueryResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_queryObj", request: updateRowsByQueryRequest)
    }

    @discardableResult
    public func updateColumnDataType(_ gridId: String, shareId: String? = nil, request updateColumnDataTypeRequest: UpdateColumnDataTypeRequest) async throws -> UpdateColumnDataTypeResponse {
        try await request(method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/update_column_datatype", request: updateColumnDataTypeRequest)
    }

    @discardableResult
    public func addColumn(_ gridId: String, request addColumnRequest: AddColumnRequest) async throws -> AddColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/add_column", request: addColumnRequest)
    }

    @discardableResult
    public func addColumns(_ gridId: String, request addColumnsRequest: AddColumnsRequest) async throws -> [AddColumnsResponse] {
        try await request(method: .POST, path: "grid/\(gridId)/add_columns", request: addColumnsRequest)
    }

    @discardableResult
    public func renameColumns(_ gridId: String, request renameColumnsRequest: RenameColumnsRequest) async throws -> RenameColumnsResponse {
        try await request(method: .POST, path: "grid/\(gridId)/rename_columns", request: renameColumnsRequest)
    }

    @discardableResult
    public func reorderColumn(_ gridId: String, request reorderColumnRequest: ReorderColumnRequest) async throws -> ReorderColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/reorder_column", request: reorderColumnRequest)
    }

    @discardableResult
    public func pinColumn(_ gridId: String, request pinColumnRequest: PinColumnRequest) async throws -> PinColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/pin_column", request: pinColumnRequest)
    }

    @discardableResult
    public func unPinColumn(_ gridId: String, request unPinColumnRequest: UnPinColumnRequest) async throws -> UnPinColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/unpin_column", request: unPinColumnRequest)
    }

    @discardableResult
    public func unPinAllColumns(_ gridId: String, request unPinAllColumnsRequest: UnPinAllColumnsRequest) async throws -> UnPinAllColumnResponse {
        try await request(method: .POST, path: "grid/\(gridId)/unpin_all_columns", request: unPinAllColumnsRequest)
    }

    @discardableResult
    public func updateColumnDescription(_ gridId: String, request updateColumnDescriptionRequest: UpdateColumnDescriptionRequest) async throws -> UpdateColumnDescriptionResponse {
        try await request(method: .POST, path: "grid/\(gridId)/update_column_desc", request: updateColumnDescriptionRequest)
    }

//    add_column

    // MARK: - Delete operations

    @discardableResult
    public func deleteTab(_ gridId: String, request deleteTabRequest: DeleteTabRequest) async throws -> DeleteTabResponse {
        try await request(method: .DELETE, path: "grid/\(gridId)/delete_tab", request: deleteTabRequest)
    }

    @discardableResult
    public func deleteRows(_ gridId: String, shareId: String? = nil, request deleteRowsRequest: DeleteRowsRequest) async throws -> DeleteRowsResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_rowIds", request: deleteRowsRequest)
    }

    @discardableResult
    public func deleteRows(_ gridId: String, shareId: String? = nil, request deleteRowsByQueryRequest: DeleteRowsByQueryRequest) async throws -> DeleteRowsByQueryResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_queryObj", request: deleteRowsByQueryRequest)
    }

    @discardableResult
    public func removeColumns(_ gridId: String, shareId: String? = nil, request removeColumnsRequest: RemoveColumnsRequest) async throws -> RemoveColumnsResponse {
        try await request(method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/remove_columns", request: removeColumnsRequest)
    }

    // MARK: - WebSocket

    public func streamGridUpdates(_ gridId: String, shareId: String = "") throws -> WebSocketStompStream {
        guard let authId = authId else {
            throw BigParserRequestError.unauthorized
        }
        let topic = "/topic/grid/\(gridId)/share_edit"

        let subscribeHeaders = [
            "authId": authId,
            "gridId": gridId,
            "shareId": shareId
        ]
        let url = Constants.websocketURLString
        return WebSocketStompStream(url: url, authId: authId, topic: topic, subscribeHeaders: subscribeHeaders)
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

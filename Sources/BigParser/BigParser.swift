import Foundation

public final class BigParser {

    // MARK: - Singleton
    public static let shared = BigParser()

    private init() {

    }

    // MARK: - Validation

    private let inputValidator = InputValidator()

    // MARK: - Type Definitions

    public var environment: Environment = .production

    public enum Environment: String {
        case qa = "https://qa.bigparser.com/"
        case production = "https://bigparser.com/"
    }

    public enum Authorization {
        case none
        case authId(String)
        case bearerToken(String)
    }

    private struct Constants {
        static let authBasePath: String = "APIServices/api/"
        static let apiV2BasePath: String = "api/v2/"
        static let apiV1BasePath: String = "APIServices/api/"
        static let websocketPath: String = "websocket-server/chat" // Must be without the forward slash at the end
    }

    private enum HTTPMethod: String {
        case GET, PUT, POST, DELETE, PATCH, CONNECT, HEAD, TRACE
    }

    // MARK: - Authentication

    @discardableResult
    public func signUp(_ signUpRequest: SignUpRequest) async throws -> SignUpResponse {
        try await request(auth: .none, basePath: Constants.authBasePath, method: .POST, path: "common/signup", request: signUpRequest)
    }

    @discardableResult
    public func logIn(_ loginRequest: LoginRequest) async throws -> LoginResponse {
        let response: LoginResponse = try await request(auth: .none, basePath: Constants.authBasePath, method: .POST, path: "common/login", request: loginRequest)

        return response
    }

    public func logOut() {
        // Does nothing for now
    }

    // MARK: - Read operations

    public func searchGrid(auth: Authorization, gridId: String, shareId: String? = nil, request searchRequest: SearchRequest) async throws -> SearchResponse {
        try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: searchRequest)
    }

    public func searchGridWithColumnNames(auth: Authorization, gridId: String, shareId: String? = nil, request searchRequest: SearchRequest) async throws -> SearchResponseWithColumnNames {
        var updatedSearchRequest = searchRequest
        updatedSearchRequest.query.showColumnNamesInResponse = true

        return try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: updatedSearchRequest)
    }

    public func searchGridWithColumnNamesEntity<T: Decodable>(auth: Authorization, gridId: String, shareId: String? = nil, request searchRequest: SearchRequest) async throws -> SearchResponseWithColumnNamesEntity<T> {
        var updatedSearchRequest = searchRequest
        updatedSearchRequest.query.showColumnNamesInResponse = true

        return try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search", request: updatedSearchRequest)
    }

    public func queryMetadata(auth: Authorization, gridId: String, shareId: String? = nil) async throws -> QueryMetadataResponse {
        try await request(auth: auth, method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_metadata")
    }

    public func queryMultiSheetMetadata(auth: Authorization, gridId: String, shareId: String? = nil) async throws -> QueryMultiSheetMetadataResponse {
        try await request(auth: auth, method: .GET, path: "\(gridPath(gridId, shareId: shareId))/query_multisheet_metadata")
    }

    public func getGrids(auth: Authorization, query: String? = nil, request getGridsRequest: GetGridsRequest) async throws -> GetGridsResponse {
        try await request(auth: auth, basePath: Constants.apiV1BasePath, method: .GET, path: "grid/get_grids", request: getGridsRequest)
    }

    public func searchCount(auth: Authorization, gridId: String, shareId: String? = nil, request searchCountRequest: SearchCountRequest) async throws -> SearchCountResponse {
        try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_count", request: searchCountRequest)
    }

    public func searchKeywordsCount(auth: Authorization, gridId: String, shareId: String? = nil, request searchKeywordsCountRequest: SearchKeywordsCountRequest) async throws -> SearchKeywordsCountResponse {
        try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/search_keywords_count", request: searchKeywordsCountRequest)
    }

    public func getUserProfile(auth: Authorization) async throws -> UserProfileResponse {
        try await request(auth: auth, basePath: Constants.apiV1BasePath, method: .GET, path: "user/profile")
    }

    // MARK: - Write operations

    @discardableResult
    public func createGrid(auth: Authorization, request createGridRequest: CreateGridRequest) async throws -> CreateGridResponse {
        if !inputValidator.isGridNameValid(createGridRequest.gridName) {
            throw BigParserRequestError.invalidGridName
        }

        return try await request(auth: auth, method: .POST, path: "grid/create_grid", request: createGridRequest)
    }

    /// The gridId represents the id of the grid which should be a parent to the new tab (which is also represented by a grid)
    @discardableResult
    public func createTab(auth: Authorization, gridId: String, request createTabRequest: CreateTabRequest) async throws -> CreateTabResponse {
        if !inputValidator.isGridNameValid(createTabRequest.tabName) {
            throw BigParserRequestError.invalidGridName
        }
        return try await request(auth: auth, method: .POST, path: "grid/\(gridId)/create_tab", request: createTabRequest)
    }

    /// The gridId represents the id of this tab
    @discardableResult
    public func updateTab(auth: Authorization, gridId: String, request updateTabRequest: UpdateTabRequest) async throws -> UpdateTabResponse {
        if !inputValidator.isGridNameValid(updateTabRequest.tabName) {
            throw BigParserRequestError.invalidGridName
        }
        return try await request(auth: auth, method: .POST, path: "grid/\(gridId)/update_tab", request: updateTabRequest)
    }

    @discardableResult
    public func insertRows(auth: Authorization, gridId: String, shareId: String? = nil, request insertRowsRequest: InsertRowsRequest) async throws -> InsertRowsResponse {
        try await request(auth: auth, method: .POST, path: "\(gridPath(gridId, shareId: shareId))/rows/create", request: insertRowsRequest)
    }

    @discardableResult
    public func updateOrInsertRows(auth: Authorization, gridId: String, shareId: String? = nil, request updateRowsRequest: UpdateRowsRequest) async throws -> UpdateRowsResponse {
        try await request(auth: auth, method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_rowIds", request: updateRowsRequest)
    }

    @discardableResult
    public func updateRows(auth: Authorization, gridId: String, shareId: String? = nil, request updateRowsByQueryRequest: UpdateRowsByQueryRequest) async throws -> UpdateRowsByQueryResponse {
        try await request(auth: auth, method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/rows/update_by_queryObj", request: updateRowsByQueryRequest)
    }

    @discardableResult
    public func updateColumnDataType(auth: Authorization, gridId: String, shareId: String? = nil, request updateColumnDataTypeRequest: UpdateColumnDataTypeRequest) async throws -> UpdateColumnDataTypeResponse {
        try await request(auth: auth, method: .PUT, path: "\(gridPath(gridId, shareId: shareId))/update_column_datatype", request: updateColumnDataTypeRequest)
    }

    @discardableResult
    public func addColumn(auth: Authorization, gridId: String, request addColumnRequest: AddColumnRequest) async throws -> AddColumnResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/add_column", request: addColumnRequest)
    }

    @discardableResult
    public func addColumns(auth: Authorization, gridId: String, request addColumnsRequest: AddColumnsRequest) async throws -> [AddColumnsResponse] {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/add_columns", request: addColumnsRequest)
    }

    @discardableResult
    public func renameColumns(auth: Authorization, gridId: String, request renameColumnsRequest: RenameColumnsRequest) async throws -> RenameColumnsResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/rename_columns", request: renameColumnsRequest)
    }

    @discardableResult
    public func reorderColumn(auth: Authorization, gridId: String, request reorderColumnRequest: ReorderColumnRequest) async throws -> ReorderColumnResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/reorder_column", request: reorderColumnRequest)
    }

    @discardableResult
    public func pinColumn(auth: Authorization, gridId: String, request pinColumnRequest: PinColumnRequest) async throws -> PinColumnResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/pin_column", request: pinColumnRequest)
    }

    @discardableResult
    public func unPinColumn(auth: Authorization, gridId: String, request unPinColumnRequest: UnPinColumnRequest) async throws -> UnPinColumnResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/unpin_column", request: unPinColumnRequest)
    }

    @discardableResult
    public func unPinAllColumns(auth: Authorization, gridId: String, request unPinAllColumnsRequest: UnPinAllColumnsRequest = UnPinAllColumnsRequest()) async throws -> UnPinAllColumnResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/unpin_all_columns", request: unPinAllColumnsRequest)
    }

    @discardableResult
    public func updateColumnDescription(auth: Authorization, gridId: String, request updateColumnDescriptionRequest: UpdateColumnDescriptionRequest) async throws -> UpdateColumnDescriptionResponse {
        try await request(auth: auth, method: .POST, path: "grid/\(gridId)/update_column_desc", request: updateColumnDescriptionRequest)
    }

    // MARK: - Delete operations

    @discardableResult
    public func deleteTab(auth: Authorization, gridId: String, request deleteTabRequest: DeleteTabRequest = DeleteTabRequest()) async throws -> DeleteTabResponse {
        try await request(auth: auth, method: .DELETE, path: "grid/\(gridId)/delete_tab", request: deleteTabRequest)
    }

    @discardableResult
    public func deleteRows(auth: Authorization, gridId: String, shareId: String? = nil, request deleteRowsRequest: DeleteRowsRequest) async throws -> DeleteRowsResponse {
        try await request(auth: auth, method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_rowIds", request: deleteRowsRequest)
    }

    @discardableResult
    public func deleteRows(auth: Authorization, gridId: String, shareId: String? = nil, request deleteRowsByQueryRequest: DeleteRowsByQueryRequest) async throws -> DeleteRowsByQueryResponse {
        try await request(auth: auth, method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/rows/delete_by_queryObj", request: deleteRowsByQueryRequest)
    }

    @discardableResult
    public func removeColumns(auth: Authorization, gridId: String, shareId: String? = nil, request removeColumnsRequest: RemoveColumnsRequest) async throws -> RemoveColumnsResponse {
        try await request(auth: auth, method: .DELETE, path: "\(gridPath(gridId, shareId: shareId))/remove_columns", request: removeColumnsRequest)
    }


    // MARK: - WebSocket

    public func streamGridUpdates(auth: Authorization, gridId: String, shareId: String? = nil) throws -> WebSocketStompStream {


        var subscribeHeaders = [
            "gridId": gridId
        ]

        var authId: String?
        switch auth {
        case .authId(let id):
            subscribeHeaders["authId"] = id
            authId = id
        case .bearerToken: // (let token):
            throw BigParserRequestError.unauthorized
//            subscribeHeaders["Bearer"] = token // This is not implemented on the backend yet
        case .none:
            throw BigParserRequestError.unauthorized
        }

        guard let authId = authId else {
            throw BigParserRequestError.unauthorized
        }

        let topic = "/topic/grid/\(gridId)/share_edit" // Must start with forward slash
        subscribeHeaders["shareId"] = shareId // Optional

        let url = environment.rawValue + Constants.websocketPath
        return WebSocketStompStream(url: url, authId: authId, topic: topic, subscribeHeaders: subscribeHeaders)
    }

    public func streamGridListUpdates(auth: Authorization, userId: String) throws -> WebSocketStompStream {
        guard case .authId(let authId) = auth else {
            throw BigParserRequestError.unauthorized
        }
        let topic = "/topic/user/\(userId)/grid_updates" // Must start with forward slash

        let subscribeHeaders = [
            "authId": authId
        ]
        let url = environment.rawValue + Constants.websocketPath
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

    private func request<Response: Decodable>(auth: Authorization, basePath: String = Constants.apiV2BasePath, method: HTTPMethod, path: String) async throws -> Response {
        try await request(auth: auth, basePath: basePath, method: method, path: path, request: NoParameters())
    }

    private func request<Request: Encodable, Response: Decodable>(auth: Authorization, basePath: String = Constants.apiV2BasePath, method: HTTPMethod, path: String, request: Request) async throws -> Response {
        return try await withCheckedThrowingContinuation({
            (continuation: CheckedContinuation<Response, Error>) in
            let url = URL(string: environment.rawValue + basePath + path)!
            var urlRequest = URLRequest(url: url)

            // NoParameters type for a request parameter means we shouldn't encode any parameters
            if request is NoParameters == false {
                do {
                    if method == .GET {
                        let queryItems = try request.getUrlQueryItems()
                        var components = URLComponents(string: url.absoluteString)!
                        components.queryItems = queryItems
                        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
                        urlRequest = URLRequest(url: components.url!)
                    } else {
                        urlRequest.httpBody = try JSONEncoder().encode(request)
                        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                } catch {
                    continuation.resume(throwing: error)
                    return
                }
            }
            urlRequest.httpMethod = method.rawValue

            switch auth {
            case .authId(let id):
                urlRequest.addValue(id, forHTTPHeaderField: "authId")
            case .bearerToken(let token):
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            case .none:
                break // Do nothing
            }

            let urlRequestCurlString = urlRequest.curlString

            URLSession.shared.dataTask(
                with: urlRequest,
                completionHandler: { data, response, error in
                    Console.log("curl:\n\(urlRequestCurlString)")
                    if let error = error {
                        Console.log("Error:\n\(error)")
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
                            Console.log("\(String(data: data, encoding: .utf8) ?? "")")

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
}


protocol AnyTypeOfArrayResponse { }
extension Array: AnyTypeOfArrayResponse { }
extension NSArray: AnyTypeOfArrayResponse { }

struct NoParameters: Encodable { }

extension Encodable {

    func getUrlQueryItems() throws -> [URLQueryItem] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        if let dictionary = json as? [String: Any] {
            return dictionary.map({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        return []
    }
}

//
//  GetGrids.swift
//  
//
//  Created by Miroslav Kutak on 02/02/2023.
//

import Foundation

public struct GetGridsRequest: Encodable {
    public var startIndex: UInt
    public var endIndex: UInt
    public let searchKeyword: String

    public init(startIndex: UInt = 1, endIndex: UInt, searchKeyword: String) {
        self.startIndex = startIndex
        self.endIndex = endIndex
        self.searchKeyword = searchKeyword
    }
}

public extension GetGridsRequest {
    init(pageSize: UInt, searchKeyword: String) {
        self.startIndex = 1
        self.endIndex = pageSize
        self.searchKeyword = searchKeyword
    }

    func addingPage(size: UInt) -> GetGridsRequest {
        var nextPage = self
        nextPage.startIndex += size
        nextPage.endIndex += size
        return nextPage
    }
}

public struct GetGridsResponse: Codable {
    public let count: Int
    public let files: [File]

    // MARK: - File
    public struct File: Codable {
        public let parseStatus: String?
        //    public let parseFailureMessage: JSONNull?
        public let gridId: String
        public let id: String
        public let fileName: String?
        public let storeFileName: String?
        public let owner: String
        public let fileType: String?
        public let shareCount: Int?
        //    public let s3GridImageInfo: JSONNull?
        //    public let filters: JSONNull?
        public let updatedDateTime: String?
        public let createdDateTime: String?
        public let isDeleted: Bool?
        //    public let syncStatus: JSONNull?
        //    public let gridSource: JSONNull?
        //    public let fileSource: JSONNull?
        public let sample: Bool?
    }

}

public extension GetGridsResponse.File {
    var name: String {
        fileName ?? storeFileName ?? ""
    }

    var nameWithoutExtension: String {
        name.components(separatedBy: ".").first ?? ""
    }
}

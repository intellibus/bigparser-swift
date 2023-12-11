//
//  QueryMetadata.swift
//
//
//  Created by Miroslav Kutak on 01/03/2023.
//

import Foundation

// No request JSON - it's a GET method

public struct QueryMetadataResponse: Codable {
    public let name: String
    public let description: String?
    public let columns: [Column]
    public let fileId, fileExtension, fileSource: String?
    public let auditGridId: String
    public let originalGridId: String?
    public let lastUpdatedTimeInBigParser: String
    public let lastUpdatedBy: String?
    public let tabName: String
    public let showRowId: Bool
    public let viewType: String // FIXME: define the enum
    public let owner, multisheet, auditGrid, template: Bool
    public let isTemplate: Bool

//        let sort: Sort
//        let sortArray: [JSONAny]
//        let imageInfo: JSONNull?
        let gridType: String // FIXME: define the enum
//        let defaultSyncPref, saveType, lastExtSrcSyncDateTime: JSONNull?
//        let defaultSaveFilter: JSONNull?
//        let filters: Filters
//        let tabDescription: JSONNull?
//        let cardViewInfo: JSONNull?
        let ownerName: String
//        let shareDetails: ShareDetails

    // MARK: - Columns
    public struct Column: Codable {
        public let columnName, columnDesc, dataType, columnIndex: String
        public let islinkedColumn, isPrimaryLink: Bool
    }
}

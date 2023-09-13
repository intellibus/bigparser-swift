//
//  UserProfile.swift
//  
//
//  Created by Miroslav Kutak on 09/13/2023.
//

import Foundation

public struct UserProfileResponse: Codable {
    public let fullName, emailId: String
    public let alternateEmailList: [AlternateEmailList]
    public let mobileNo: String
    public let s3Info: S3Info?
    public let myDataFTU, parseDataFTU: Bool
    public let userGridIdList: [UserGridIdList]
    public let myDataDefaultViewType: String
    public let loggedIn: Bool
    public let userId, streamId: String
    public let affiliate, primaryEmailIdVerified, isPrimaryEmailIdVerified: Bool

    // MARK: - AlternateEmailList
    public struct AlternateEmailList: Codable {
        public let emailId: String
        public let isVerified: Bool
    }

    // MARK: - S3Info
    public struct S3Info: Codable {
        public let bucketName, expires, authorization, date: String
        public let key: String
    }

    // MARK: - UserGridIdList
    public struct UserGridIdList: Codable {
        public let gridId, gridType: String
    }
}

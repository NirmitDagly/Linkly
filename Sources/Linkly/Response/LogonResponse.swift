//
//  LogonResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct LogonResponse: Codable {
    var linklyLogonSessionID: String?
    var linklyLogonResponseType: String
    var linklyLogonsponse: LinklyLogonResponse
    
    enum CodingKeys: String, CodingKey {
        case linklyLogonSessionID = "sessionId"
        case linklyLogonResponseType = "responseType"
        case linklyLogonsponse = "response"
    }
}

struct LogonResponseMapper: Mappable {
    
    func map(_ input: LogonResponse) throws -> Logon {
        return .init(linklyLogonSessionID: input.linklyLogonSessionID ?? "",
                     linklyLogonResponseType: input.linklyLogonResponseType,
                     linklyLogonsponse: try LinklyLogonResponseMapper().map(input.linklyLogonsponse)
        )
    }
}

struct LinklyLogonResponse: Codable {
    var pinPadVersion: String
    var success: Bool
    var responseCode: String
    var responseText: String
    var date: String
    var catID: String
    var caID: String
    var stan: Int
    
    enum CodingKeys: String, CodingKey {
        case pinPadVersion
        case success
        case responseCode
        case responseText
        case date
        case catID = "catid"
        case caID = "caid"
        case stan
    }
}

struct LinklyLogonResponseMapper: Mappable {
    
    func map(_ input: LinklyLogonResponse) throws -> LinklyLogon {
        return .init(pinPadVersion: input.pinPadVersion,
                     success: input.success,
                     responseCode: input.responseCode,
                     responseText: input.responseText,
                     date: input.date,
                     catID: input.catID,
                     caID: input.caID,
                     stan: input.stan
        )
    }
}

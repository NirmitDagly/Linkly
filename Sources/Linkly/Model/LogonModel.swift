//
//  Logon.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct Logon: Codable {
    public var linklyLogonSessionID: String?
    public var linklyLogonResponseType: String
    public var linklyLogonsponse: LinklyLogon
}

public struct LinklyLogon: Codable {
    var pinPadVersion: String
    var success: Bool
    var responseCode: String
    var responseText: String
    var date: String
    var catID: String
    var caID: String
    var stan: Int
}


//
//  Logon.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

struct Logon: Codable {
    var linklyLogonSessionID: String?
    var linklyLogonResponseType: String
    var linklyLogonsponse: LinklyLogon
}

struct LinklyLogon: Codable {
    var pinPadVersion: String
    var success: Bool
    var responseCode: String
    var responseText: String
    var date: String
    var catID: String
    var caID: String
    var stan: Int
}


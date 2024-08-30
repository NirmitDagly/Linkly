//
//  SendKey.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct SendKey: Codable {
    var sessionId: String?
    var responseType: String
    var response: String?
}

//
//  SendKey.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import HTTPNetwork

public struct SendKey: Codable {
    public var sessionId: String?
    public var responseType: String
    public var response: String?
}

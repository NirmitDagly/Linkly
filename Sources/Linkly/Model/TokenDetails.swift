//
//  TokenDetails.swift
//
//
//  Created by Miamedia Developer on 02/10/24.
//

import Foundation
import SwiftUI
import Network

public struct TokenDetails: Codable {
    public var authSecret: String
    public var authToken: String
    public var tokenExpiryTime: Double
}

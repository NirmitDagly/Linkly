//
//  AuthTokenModel.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import Network

public struct AuthTokenModel: Codable {
    var token: String
    var expirySeconds: Double
}

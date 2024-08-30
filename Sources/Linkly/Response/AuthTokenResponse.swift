//
//  AuthTokenResponse.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import Network

public struct AuthTokenResponse: Codable {
    public var token: String
    public var expirySeconds: Double

    enum CodingKeys: String, CodingKey {
        case token
        case expirySeconds
    }
}

struct AuthTokenResponseMapper: Mappable {
    
    func map(_ input: AuthTokenResponse) -> AuthTokenModel {
        return .init(
            token: input.token,
            expirySeconds: input.expirySeconds
        )
    }
}

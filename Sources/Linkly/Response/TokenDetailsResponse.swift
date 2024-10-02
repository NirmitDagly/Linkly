//
//  TokenDetailsResponse.swift
//
//
//  Created by Miamedia Developer on 02/10/24.
//

import Foundation
import SwiftUI
import Network

public struct TokenDetailsResponse: Codable {
    public var authSecret: String
    public var authToken: String
    public var tokenExpiryTime: Double
}

public struct TokenDetailsResponseMapper: Mappable {
    
    public func map(_ input: TokenDetailsResponse) -> TokenDetails {
        return .init(
            authSecret: input.authSecret,
            authToken: input.authToken,
            tokenExpiryTime: input.tokenExpiryTime
        )
    }
}

//
//  SendKeyResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct SendKeyResponse: Codable {
    public var sessionId: String?
    public var responseType: String
    public var response: String?

    enum CodingKeys: String, CodingKey {
        case sessionId
        case responseType
        case response
    }
}

struct SendKeyResponseResponseMapper: Mappable {
    
    func map(_ input: SendKeyResponse) -> SendKey {
        return .init(sessionId: input.sessionId ?? "",
                     responseType: input.responseType,
                     response: input.response ?? ""
        )
    }
}

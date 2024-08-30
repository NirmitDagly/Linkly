//
//  SendKeyResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct SendKeyResponse: Codable {
    var sessionId: String?
    var responseType: String
    var response: String?

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

//
//  RefundResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct RefundResponse: Codable {
    public var linklyRefundSessionID: String?
    public var linklyRefundResponseType: String
    public var linklyRefundResponse: LinklyTransactionResponse
    
    enum CodingKeys: String, CodingKey {
        case linklyRefundSessionID = "sessionId"
        case linklyRefundResponseType = "responseType"
        case linklyRefundResponse = "response"
    }
}

struct RefundResponseMapper: Mappable {
    
    func map(_ input: RefundResponse) throws -> Refund {
        return .init(linklyRefundSessionID: input.linklyRefundSessionID ?? "",
                     linklyRefundResponseType: input.linklyRefundResponseType,
                     linklyRefund: try LinklyTransactionResponseMapper().map(input.linklyRefundResponse)
        )
    }
}

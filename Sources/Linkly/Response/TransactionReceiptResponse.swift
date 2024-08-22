//
//  TransactionReceiptResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

struct TransactionReceiptResponse: Codable {
    var responseType: String
    var response: TransactionReceiptDetailsResponse

    enum CodingKeys: String, CodingKey {
        case responseType = "responseType"
        case response = "response"
    }
}

struct TransactionReceiptResponseMapper: Mappable {
    
    func map(_ input: TransactionReceiptResponse) throws -> TransactionReceipt {
        return .init(responseType: input.responseType,
                     response: try TransactionReceiptDetailsResponseMapper().map(input.response)
        )
    }
}

struct TransactionReceiptDetailsResponse: Codable {
    var merchant: String
    var receiptText: [String]
    var success: Bool
    var responseCode: String
    var responseText: String
    
    enum CodingKeys: String, CodingKey {
        case merchant
        case receiptText
        case success
        case responseCode
        case responseText
    }
}

struct TransactionReceiptDetailsResponseMapper: Mappable {
    func map(_ input: TransactionReceiptDetailsResponse) throws -> TransactionReceiptDetails {
        return .init(merchant: input.merchant,
                     receiptText: input.receiptText,
                     success: input.success,
                     responseCode: input.responseCode,
                     responseText: input.responseText
        )
    }
}

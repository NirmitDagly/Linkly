//
//  TransactionReceipt.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct TransactionReceipt: Codable {
    public var responseType: String
    public var response: TransactionReceiptDetails
}

public struct TransactionReceiptDetails: Codable {
    var merchant: String
    var receiptText: [String]
    var success: Bool
    var responseCode: String
    var responseText: String
}

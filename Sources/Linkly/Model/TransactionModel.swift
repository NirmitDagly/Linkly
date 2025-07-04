//
//  TransactionModel.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import SwiftUI
import Network

public struct TransactionModel: Codable {
    public var linklyTransactionSessionID: String?
    public var linklyTransactionType: String
    public var linklyTransaction: LinklyTransaction
}

public struct LinklyTransaction: Codable {
    public var sessionId: String?
    public var txnType: String
    public var merchant: String
    public var cardType: String
    public var cardName: String
    public var rrn: String
    public var dateSettlement: String
    public var amtCash: Int
    public var amtPurchase: Int
    public var amtTip: Int
    public var authCode: Int
    public var txnRef: String
    public var pan: String
    public var dateExpiry: String
    public var track2: String?
    public var accountType: String
    public var balanceReceived: Bool
    public var availableBalance: Int
    public var clearedFundsBalance: Int?
    public var success: Bool
    public var responseCode: String
    public var responseText: String
    public var date: String
    public var catID: String
    public var caID: String
    public var stan: Int
    public var txnFlags: TransactionFlags
    public var purchaseAnalysisData: PurchaseAnalysisData?
    public var receipts: [LinklyTransactionReceipts]?
}

public struct TransactionFlags: Codable {
    public var offline: String
    public var receiptPrinted: String
    public var cardEntry: String
    public var commsMethod: String
    public var currency: String
    public var payPass: String
    public var undefinedFlag6: String
    public var undefinedFlag7: String
}

public struct PurchaseAnalysisData: Codable {
    public var rfn: String?
    public var ref: String?
    public var hrc: String?
    public var hrt: String?
    public var sur: String?
    public var amt: String?
    public var cem: String?
}

public struct LinklyTransactionReceipts: Codable {
    public var type: String
    public var receiptText: [String]
}

//
//  TransactionModel.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import SwiftUI
import Network

struct TransactionModel: Codable {
    var linklyTransactionSessionID: String?
    var linklyTransactionType: String
    var linklyTransaction: LinklyTransaction
}

struct LinklyTransaction: Codable {
    var txnType: String
    var merchant: String
    var cardType: String
    var cardName: String
    var rrn: String
    var dateSettlement: String
    var amtCash: Int
    var amtPurchase: Int
    var amtTip: Int
    var authCode: Int
    var txnRef: String
    var pan: String
    var dateExpiry: String
    var track2: String?
    var accountType: String
    var balanceReceived: Bool
    var availableBalance: Int
    var clearedFundsBalance: Int?
    var success: Bool
    var responseCode: String
    var responseText: String
    var date: String
    var catID: String
    var caID: String
    var stan: Int
    var txnFlags: TransactionFlags
    var purchaseAnalysisData: PurchaseAnalysisData?
    var receipts: [LinklyTransactionReceipts]?
}

struct TransactionFlags: Codable {
    var offline: String
    var receiptPrinted: String
    var cardEntry: String
    var commsMethod: String
    var currency: String
    var payPass: String
    var undefinedFlag6: String
    var undefinedFlag7: String
}

struct PurchaseAnalysisData: Codable {
    var rfn: String?
    var ref: String?
    var hrc: String?
    var hrt: String?
    var sur: String?
    var amt: String?
    var cem: String?
}

struct LinklyTransactionReceipts: Codable {
    var type: String
    var receiptText: [String]
}

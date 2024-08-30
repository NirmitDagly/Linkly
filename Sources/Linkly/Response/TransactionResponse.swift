//
//  TransactionResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import SwiftUI
import Network

public struct TransactionModelResponse: Codable {
    var linklyTransactionSessionID: String?
    var linklyTransactionResponseType: String
    var linklyTransactionResponse: LinklyTransactionResponse
    
    enum CodingKeys: String, CodingKey {
        case linklyTransactionSessionID = "sessionId"
        case linklyTransactionResponseType = "responseType"
        case linklyTransactionResponse = "response"
    }
}

struct TransactionModelResponseMapper: Mappable {
    public func map(_ input: TransactionModelResponse) throws -> TransactionModel {
        return .init(linklyTransactionSessionID: input.linklyTransactionSessionID ?? "",
                     linklyTransactionType: input.linklyTransactionResponseType,
                     linklyTransaction: try LinklyTransactionResponseMapper().map(input.linklyTransactionResponse)
        )
    }
}

struct LinklyTransactionResponse: Codable {
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
    var txnFlags: TransactionFlagsResponse
    var purchaseAnalysisData: PurchaseAnalysisDataResponse?
    var receipts: [LinklyTransactionReceiptsResponse]?
    
    enum CodingKeys: String, CodingKey {
        case txnType
        case merchant
        case cardType
        case cardName
        case rrn
        case dateSettlement
        case amtCash
        case amtPurchase
        case amtTip
        case authCode
        case txnRef
        case pan
        case dateExpiry
        case track2
        case accountType
        case balanceReceived
        case availableBalance
        case clearedFundsBalance
        case success
        case responseCode
        case responseText
        case date
        case catID = "catid"
        case caID = "caid"
        case stan
        case txnFlags
        case purchaseAnalysisData
        case receipts
    }
}

struct LinklyTransactionResponseMapper: Mappable {
    func map(_ input: LinklyTransactionResponse) throws -> LinklyTransaction {
        return .init(txnType: input.txnType,
                     merchant: input.merchant,
                     cardType: input.cardType,
                     cardName: input.cardName,
                     rrn: input.rrn,
                     dateSettlement: input.dateSettlement,
                     amtCash: input.amtCash,
                     amtPurchase: input.amtPurchase,
                     amtTip: input.amtTip,
                     authCode: input.authCode,
                     txnRef: input.txnRef,
                     pan: input.pan,
                     dateExpiry: input.dateExpiry,
                     track2: input.track2 ?? "",
                     accountType: input.accountType,
                     balanceReceived: input.balanceReceived,
                     availableBalance: input.availableBalance,
                     clearedFundsBalance: input.clearedFundsBalance ?? 0,
                     success: input.success,
                     responseCode: input.responseCode,
                     responseText: input.responseText,
                     date: input.date,
                     catID: input.catID,
                     caID: input.caID,
                     stan: input.stan,
                     txnFlags: try TransactionFlagsResponseMapper().map(input.txnFlags),
                     purchaseAnalysisData: try PurchaseAnalysisDataResponseMapper().map(input.purchaseAnalysisData ??
                                                                                        PurchaseAnalysisDataResponse(rfn: "",
                                                                                                                     ref: "",
                                                                                                                     hrc: "",
                                                                                                                     hrt: "",
                                                                                                                     sur: "",
                                                                                                                     amt: "",
                                                                                                                     cem: ""
                                                                                                                    )
                                                                                       ),
                     receipts: try input.receipts?.map { try LinklyTransactionReceiptsMapper().map($0) }
        )
    }
}

struct TransactionFlagsResponse: Codable {
    var offline: String
    var receiptPrinted: String
    var cardEntry: String
    var commsMethod: String
    var currency: String
    var payPass: String
    var undefinedFlag6: String
    var undefinedFlag7: String
    
    enum CodingKeys: String, CodingKey {
        case offline
        case receiptPrinted
        case cardEntry
        case commsMethod
        case currency
        case payPass
        case undefinedFlag6
        case undefinedFlag7
    }
}

struct TransactionFlagsResponseMapper: Mappable {
    func map(_ input: TransactionFlagsResponse) throws -> TransactionFlags {
        return .init(offline: input.offline,
                     receiptPrinted: input.receiptPrinted,
                     cardEntry: input.cardEntry,
                     commsMethod: input.commsMethod,
                     currency: input.currency,
                     payPass: input.payPass,
                     undefinedFlag6: input.undefinedFlag6,
                     undefinedFlag7: input.undefinedFlag7
        )
    }
}

struct PurchaseAnalysisDataResponse: Codable {
    var rfn: String?
    var ref: String?
    var hrc: String?
    var hrt: String?
    var sur: String?
    var amt: String?
    var cem: String?
    
    enum CodingKeys: String, CodingKey {
        case rfn
        case ref
        case hrc
        case hrt
        case sur
        case amt
        case cem
    }
}

struct PurchaseAnalysisDataResponseMapper: Mappable {
    func map(_ input: PurchaseAnalysisDataResponse) throws -> PurchaseAnalysisData {
        return .init(rfn: input.rfn ?? "",
                     ref: input.ref ?? "",
                     hrc: input.hrc ?? "",
                     hrt: input.hrt ?? "",
                     sur: input.sur ?? "",
                     amt: input.amt ?? "",
                     cem: input.cem ?? ""
        )
    }
}

struct LinklyTransactionReceiptsResponse: Codable {
    var type: String
    var receiptText: [String]
}

struct LinklyTransactionReceiptsMapper: Mappable {
    func map(_ input: LinklyTransactionReceiptsResponse) throws -> LinklyTransactionReceipts {
        return .init(type: input.type,
                     receiptText: input.receiptText
        )
    }
}

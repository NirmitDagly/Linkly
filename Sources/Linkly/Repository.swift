//
//  Repository.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import Network
import Logger

protocol TerminalOperationRepository {
    
    func pairTerminal(withTerminalNumber terminalNumber: String,
                      andUsername username: String,
                      andPassword password: String,
                      andPairingCode pairCode: String
    ) async throws -> PairingModel
    
    func getAuthToken(withSecret secret: String,
                      forPOS posName: String,
                      andPOSVersion posVersion: String,
                      andPOSID posID: String,
                      andPOSVendorID vendorID: String
    ) async throws -> AuthTokenModel
    
    
    func checkTerminalStatus(withSessionID sessionID: String) async throws -> TerminalStatus
    
    func logOnToTerminal(withSessionID sessionID: String) async throws -> Logon
}

public class TerminalPairing: TerminalOperationRepository {

    private let apiClientService: APIClientService

    public init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
    
    public func pairTerminal(withTerminalNumber terminalNumber: String,
                             andUsername username: String,
                             andPassword password: String,
                             andPairingCode pairCode: String
    ) async throws -> PairingModel {
        try await apiClientService.request(
            APIEndPoints.initiatePairing(withTerminalNumber: terminalNumber,
                                         andUsername: username,
                                         andPassword: password,
                                         andPairingCode: pairCode
                                        ),
            mapper: PairingResponseMapper()
        )
    }
    
    public func getAuthToken(withSecret secret: String,
                             forPOS posName: String,
                             andPOSVersion posVersion: String,
                             andPOSID posID: String,
                             andPOSVendorID vendorID: String
    ) async throws -> AuthTokenModel {
        try await apiClientService.request(
            APIEndPoints.getAuthToken(withSecret: secret,
                                      forPOS: posName,
                                      andPOSVersion: posVersion,
                                      andPOSID: posID,
                                      andPOSVendorID: vendorID
                                     ),
            mapper: AuthTokenResponseMapper()
        )
    }

    public func checkTerminalStatus(withSessionID sessionID: String) async throws -> TerminalStatus {
        try await apiClientService.request(
            APIEndPoints.checkTerminalStatus(withSessionID: sessionID),
            mapper: TerminalStatusResponseMapper()
        )
    }
    
    public func logOnToTerminal(withSessionID sessionID: String) async throws -> Logon {
        try await apiClientService.request(
            APIEndPoints.logonToPinpad(withSessionID: sessionID),
            mapper: LogonResponseMapper()
        )
    }
}


protocol TransactionRepository {
    
    func initiateTransaction(withSessionID sessionID: String,
                             andMerchant merchant: String,
                             withTxnType txnType: String,
                             forPurchaseAmount amount: String,
                             withTxnRefNumber txnRefNumber: String,
                             andCurrencyCode currencyCode: String,
                             withCutReceiptOption cutReceipt: String,
                             onApplication application: String,
                             withTipEnabled enableTip: Int,
                             andShouldAutoPrintReceipt autoPrintReceipt: String,
                             andPurchaseAnalysisData purchaseAnalysisData: [String: Any]
    ) async throws -> TransactionModel
    
    func refundTransaction(withSessionID sessionID: String,
                           andMerchant merchant: String,
                           withTxnType txnType: String,
                           forPurchaseAmount amount: String,
                           withTxnRefNumber txnRefNumber: String,
                           andCurrencyCode currencyCode: String,
                           withCutReceiptOption cutReceipt: String,
                           onApplication application: String,
                           withTipEnabled enableTip: Int,
                           andShouldAutoPrintReceipt autoPrintReceipt: String,
                           andPurchaseAnalysisData purchaseAnalysisData: [String: Any]
    ) async throws -> Refund
    
    func cancelTransaction(forSessionID sessionID: String) async throws -> SendKey
    
    func getTransactionStatus(forSessionID sessionID: String) async throws -> TransactionModel
    
    func getTransactionReceipts(withSessionID sessionID: String,
                                andMerchant merchant: String,
                                withTxnRefNumber txnRefNumber: String,
                                onApplication application: String,
                                andShouldAutoPrintReceipt autoPrintReceipt: String,
                                andReceiptReprintType reprintType: String
    ) async throws -> TransactionReceipt
}

public class TransactionControl: TransactionRepository {
    
    private let apiClientService: APIClientService

    public init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
    
    public func initiateTransaction(withSessionID sessionID: String,
                                    andMerchant merchant: String,
                                    withTxnType txnType: String,
                                    forPurchaseAmount amount: String,
                                    withTxnRefNumber txnRefNumber: String,
                                    andCurrencyCode currencyCode: String,
                                    withCutReceiptOption cutReceipt: String,
                                    onApplication application: String,
                                    withTipEnabled enableTip: Int,
                                    andShouldAutoPrintReceipt autoPrintReceipt: String,
                                    andPurchaseAnalysisData purchaseAnalysisData: [String: Any]
    ) async throws -> TransactionModel {
        try await apiClientService.request(
            APIEndPoints.initiateTransaction(withSessionID: sessionID,
                                             andMerchant: merchant,
                                             withTxnType: txnType,
                                             forPurchaseAmount: amount,
                                             withTxnRefNumber: txnRefNumber,
                                             andCurrencyCode: currencyCode,
                                             withCutReceiptOption: cutReceipt,
                                             onApplication: application,
                                             withTipEnabled: enableTip,
                                             andShouldAutoPrintReceipt: autoPrintReceipt,
                                             andPurchaseAnalysisData: purchaseAnalysisData
                                            ),
            mapper: TransactionModelResponseMapper()
        )
    }
    
    public func refundTransaction(withSessionID sessionID: String,
                                  andMerchant merchant: String,
                                  withTxnType txnType: String,
                                  forPurchaseAmount amount: String,
                                  withTxnRefNumber txnRefNumber: String,
                                  andCurrencyCode currencyCode: String,
                                  withCutReceiptOption cutReceipt: String,
                                  onApplication application: String,
                                  withTipEnabled enableTip: Int,
                                  andShouldAutoPrintReceipt autoPrintReceipt: String,
                                  andPurchaseAnalysisData purchaseAnalysisData: [String: Any]
    ) async throws -> Refund {
        try await apiClientService.request(
            APIEndPoints.initiateRefund(withSessionID: sessionID,
                                        andMerchant: merchant,
                                        withTxnType: txnType,
                                        forPurchaseAmount: amount,
                                        withTxnRefNumber: txnRefNumber,
                                        andCurrencyCode: currencyCode,
                                        withCutReceiptOption: cutReceipt,
                                        onApplication: application,
                                        withTipEnabled: enableTip,
                                        andShouldAutoPrintReceipt: autoPrintReceipt,
                                        andPurchaseAnalysisData: purchaseAnalysisData
                                       ),
            mapper: RefundResponseMapper()
        )
    }
    
    public func cancelTransaction(forSessionID sessionID: String) async throws -> SendKey {
        try await apiClientService.request(
            APIEndPoints.cancelTransaction(forSessionID: sessionID),
            mapper: SendKeyResponseResponseMapper()
        )
    }
    
    public func getTransactionStatus(forSessionID sessionID: String) async throws -> TransactionModel {
        
        try await apiClientService.request(
            APIEndPoints.getTransactionStatus(forSessionID: sessionID),
            mapper: TransactionModelResponseMapper()
        )
    }
    
    public func getTransactionReceipts(withSessionID sessionID: String,
                                       andMerchant merchant: String,
                                       withTxnRefNumber txnRefNumber: String,
                                       onApplication application: String,
                                       andShouldAutoPrintReceipt autoPrintReceipt: String,
                                       andReceiptReprintType reprintType: String
    ) async throws -> TransactionReceipt {
        try await apiClientService.request(
            APIEndPoints.getTransactionReceipt(withSessionID: sessionID,
                                               andMerchant: merchant,
                                               withTxnRefNumber: txnRefNumber,
                                               onApplication: application,
                                               andShouldAutoPrintReceipt: autoPrintReceipt,
                                               andReceiptReprintType: reprintType
                                              ),
            mapper: TransactionReceiptResponseMapper()
        )
    }
}


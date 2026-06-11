//
//  TransactionRepositoryImpl.swift
//  Linkly
//
//  Created by Miamedia on 11/6/2026.
//

import Foundation
import SwiftUI
import HTTPNetwork
import Logger

public class TransactionControl: TransactionRepository {
    
    private let apiClientService: APIClientService

    public init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
    
    public func checkTerminalStatus(withSessionID sessionID: String) async throws -> DecodedResponse<TerminalStatus> {
        try await apiClientService.request(
            APIEndPoints.checkTerminalStatus(withSessionID: sessionID),
            mapper: TerminalStatusResponseMapper()
        )
    }
    
    public func logOnToTerminal(withSessionID sessionID: String) async throws -> DecodedResponse<Logon> {
        try await apiClientService.request(
            APIEndPoints.logonToPinpad(withSessionID: sessionID),
            mapper: LogonResponseMapper()
        )
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
    ) async throws -> DecodedResponse<TransactionModel> {
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
                                  forRefundAmount amount: String,
                                  withTxnRefNumber txnRefNumber: String,
                                  andCurrencyCode currencyCode: String,
                                  withCutReceiptOption cutReceipt: String,
                                  onApplication application: String,
                                  withTipEnabled enableTip: Int,
                                  andShouldAutoPrintReceipt autoPrintReceipt: String,
                                  andPurchaseAnalysisData purchaseAnalysisData: [String: Any]
    ) async throws -> DecodedResponse<Refund> {
        try await apiClientService.request(
            APIEndPoints.initiateRefund(withSessionID: sessionID,
                                        andMerchant: merchant,
                                        withTxnType: txnType,
                                        forRefundAmount: amount,
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
    
    public func cancelTransaction(forSessionID sessionID: String) async throws -> DecodedResponse<SendKey> {
        try await apiClientService.request(
            APIEndPoints.cancelTransaction(forSessionID: sessionID),
            mapper: SendKeyResponseResponseMapper()
        )
    }
    
    public func getTransactionStatus(forSessionID sessionID: String) async throws -> DecodedResponse<TransactionModel> {
        
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
    ) async throws -> DecodedResponse<TransactionReceipt> {
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
    
    public func getTransactionProgress(forSessionID sessionID: String) async throws -> DecodedResponse<TransactionModel> {
        try await apiClientService.request(
            APIEndPoints.getTransactionProgressStatus(forSessionID: sessionID),
            mapper: TransactionModelResponseMapper()
        )
    }
}

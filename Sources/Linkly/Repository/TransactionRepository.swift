//
//  TransactionRepository.swift
//  Linkly
//
//  Created by Miamedia on 11/6/2026.
//

import Foundation
import HTTPNetwork

protocol TransactionRepository {
    func checkTerminalStatus(withSessionID sessionID: String) async throws -> DecodedResponse<TerminalStatus>
    
    func logOnToTerminal(withSessionID sessionID: String) async throws -> DecodedResponse<Logon>

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
    ) async throws -> DecodedResponse<TransactionModel>
    
    func refundTransaction(withSessionID sessionID: String,
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
    ) async throws -> DecodedResponse<Refund>
    
    func cancelTransaction(forSessionID sessionID: String) async throws -> DecodedResponse<SendKey>
    
    func getTransactionStatus(forSessionID sessionID: String) async throws -> DecodedResponse<TransactionModel>
    
    func getTransactionReceipts(withSessionID sessionID: String,
                                andMerchant merchant: String,
                                withTxnRefNumber txnRefNumber: String,
                                onApplication application: String,
                                andShouldAutoPrintReceipt autoPrintReceipt: String,
                                andReceiptReprintType reprintType: String
    ) async throws -> DecodedResponse<TransactionReceipt>
    func getTransactionProgress(forSessionID sessionID: String) async throws -> DecodedResponse<TransactionModel>
}

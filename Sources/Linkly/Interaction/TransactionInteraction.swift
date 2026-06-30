//
//  TransactionInteraction.swift
//
//
//  Created by Miamedia Developer on 01/10/24.
//

import Foundation
import Logger
import HTTPNetwork
import SwiftUI
import DesignSystem

//MARK: Setup configuration for transaction
class LinklyTransactionConfiguration: ObservableObject {

    let apiClientService: APIClientService
    
    init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
}

class TransactionConfiguration: ObservableObject {
    let configuration: LinklyTransactionConfiguration
    
    init(isProductionMode prodMode: Bool) {
        var apiClientService = APIClientService(configuration: .init(baseURL: URL(string: "https://rest.pos.sandbox.cloud.pceftpos.com"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(configuration: .init(baseURL: URL(string: "https://rest.pos.cloud.pceftpos.com"),
                                                                         baseHeaders: ["Accept": "application/json",
                                                                                       "content-type": "application/json"
                                                                                      ]
                                                                        )
            )
        }
        
        configuration = .init(apiClientService: apiClientService)
    }
}

final public class TransactionInteraction: ObservableObject {
    var transactionControl: TransactionControl
    
    public init(isProductionMode mode: Bool,
                andAuthToken token: String
    ) {
        self.transactionControl = TransactionControl.init(apiClientService: TransactionConfiguration(isProductionMode: mode).configuration.apiClientService)
        authToken = token
    }
    
    public func generateSessionID() -> String {
        return NSUUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
    }
    
    public func getTransactionReferenceNumber() -> String {
        var txnRefNumber = "\(1)" + "-" + Date().toString(format: "dd/MM/yyyy hh:mm:ss")
        txnRefNumber = txnRefNumber.replacingOccurrences(of: "/", with: "")
        txnRefNumber = txnRefNumber.replacingOccurrences(of: "-", with: "")
        txnRefNumber = txnRefNumber.replacingOccurrences(of: " ", with: "")
        txnRefNumber = txnRefNumber.replacingOccurrences(of: ":", with: "")
        return String(txnRefNumber.prefix(16))
    }
}

extension TransactionInteraction {
    
    public func checkPinpadStatus(withSessionId sessionId: String) async throws -> TerminalStatus {
        do {
            async let checkPinpadStatus = transactionControl.checkTerminalStatus(withSessionID: sessionId)
            let pinpadStatus = try await checkPinpadStatus
            return pinpadStatus.model!
        } catch {
            throw error
        }
    }

    public func initiatePaymentWithLinkly(withSessionId sessionId: String,
                                          forPurchaseAmount amount: String,
                                          andTxnRefNumber txnRefNumber: String,
                                          andTippingEnabled tippingEnabled: Bool
    ) async throws -> (Int, TransactionModel) {
        var transactionModel = demoTransactionModel
        do {
            async let getTransactionResponse = transactionControl.initiateTransaction(withSessionID: sessionId,
                                                                                      andMerchant: "00",
                                                                                      withTxnType: "P",
                                                                                      forPurchaseAmount: amount,
                                                                                      withTxnRefNumber: txnRefNumber,
                                                                                      andCurrencyCode: "AUD",
                                                                                      withCutReceiptOption: "0",
                                                                                      onApplication: "00",
                                                                                      withTipEnabled: tippingEnabled ? 1 : 0,
                                                                                      andShouldAutoPrintReceipt: "7",
                                                                                      andPurchaseAnalysisData: ["AMT": amount,
                                                                                                                "PCM": "0000"] as [String: Any]
            )
            let transactionResponseDetails = try await getTransactionResponse
            if (transactionResponseDetails.statusCode == 200 || transactionResponseDetails.statusCode == 201) && transactionResponseDetails.model != nil {
                transactionModel = transactionResponseDetails.model!
                async let getTransactionReceipt = await getTransactionReceipt(forTxnRefNumber: txnRefNumber)
                transactionModel.linklyTransaction.receipts = try await getTransactionReceipt
                transactionModel.linklyTransaction.sessionId = sessionId
            }
            return (transactionResponseDetails.statusCode, transactionModel)
        } catch {
            throw error
        }
    }
    
    public func refundPaymentWithLinkly(withSessionId sessionId: String,
                                        forRefundAmount amount: String,
                                        andTxnRefNumber txnRefNumber: String
    ) async throws -> (Int, Refund) {
        var refundModel = demoRefundModel
        do {
            async let getRefundResponse = transactionControl.refundTransaction(withSessionID: sessionId,
                                                                               andMerchant: "00",
                                                                               withTxnType: "R",
                                                                               forRefundAmount: amount,
                                                                               withTxnRefNumber: txnRefNumber,
                                                                               andCurrencyCode: "AUD",
                                                                               withCutReceiptOption: "0",
                                                                               onApplication: "00",
                                                                               withTipEnabled: 1,
                                                                               andShouldAutoPrintReceipt: "7",
                                                                               andPurchaseAnalysisData: ["AMT": amount,
                                                                                                         "PCM": "0000"] as [String: Any]
            )
            
            let refundResponseDetails = try await getRefundResponse
            if (refundResponseDetails.statusCode == 200 || refundResponseDetails.statusCode == 201) && refundResponseDetails.model != nil {
                print(refundResponseDetails)
                refundModel = refundResponseDetails.model!
                async let getRefundReceipt = await getTransactionReceipt(forTxnRefNumber: txnRefNumber)
                refundModel.linklyRefund.receipts = try await getRefundReceipt
                refundModel.linklyRefund.sessionId = sessionId
            }
            return (refundResponseDetails.statusCode, refundModel)
        } catch {
            throw error
        }
    }
    
    public func cancelPaymentWithLinkly(withSessionId sessionId: String,
                                        andTxnRefNumber txnRefNumber: String
    ) async throws -> String {
        do {
            async let getTransactionResponse = transactionControl.cancelTransaction(forSessionID: sessionId)
            let transactionResponseDetails = try await getTransactionResponse
            print(transactionResponseDetails)
            guard transactionResponseDetails.model != nil, transactionResponseDetails.model!.response != "" else {
                return "Ok"
            }
            
            return transactionResponseDetails.model!.response!
        } catch {
            throw error
        }
    }
    
    public func getTransactionReceipt(forTxnRefNumber txnRefNumber: String) async throws -> [LinklyTransactionReceipts] {
        var linklyReceipts = [LinklyTransactionReceipts]()
        do {
            async let getTransctionReceiptResponse = try transactionControl.getTransactionReceipts(withSessionID: generateSessionID(),
                                                                                                   andMerchant: "00",
                                                                                                   withTxnRefNumber: txnRefNumber,
                                                                                                   onApplication: "00",
                                                                                                   andShouldAutoPrintReceipt: "7",
                                                                                                   andReceiptReprintType: "1"
            )
            let transactionReceiptResponseDetails = try await getTransctionReceiptResponse
            
            if (transactionReceiptResponseDetails.statusCode == 200 || transactionReceiptResponseDetails.statusCode == 201) && transactionReceiptResponseDetails.model != nil {
                //Get receipt for transaction. Only merchant receipt will be received in response
                //If response fails, then return the transaction model response without receipt(s)
                let receiptText = LinklyTransactionReceipts(
                    type: transactionReceiptResponseDetails.model!.response.responseText,
                    receiptText: transactionReceiptResponseDetails.model!.response.receiptText
                )
                linklyReceipts.append(receiptText)
                
                //Get the receipt updated for merchant
                var receiptTextToUpdate = receiptText.receiptText.joined(separator: ",")
                receiptTextToUpdate = receiptTextToUpdate.replacingOccurrences(
                    of: "MERCHANT",
                    with: "CUSTOMER"
                )
                
                let updatedReceipt = LinklyTransactionReceipts(
                    type: transactionReceiptResponseDetails.model!.response.responseText,
                    receiptText: receiptTextToUpdate.components(separatedBy: ",")
                )
                linklyReceipts.append(updatedReceipt)
            }
            return linklyReceipts
        } catch {
            throw error
        }
    }
     
    public func getTransactionProgressStatus(forSessionID sessionID: String,
                                             andTxnRefNumber txnRefNumber: String
    ) async throws -> (Int, TransactionModel) {
        var transactionModel = demoTransactionModel
        do {
            async let getTransactionResponse = transactionControl.getTransactionProgress(forSessionID: sessionID)
            
            let transactionResponseDetails = try await getTransactionResponse
            if (transactionResponseDetails.statusCode == 200 || transactionResponseDetails.statusCode == 201) && transactionResponseDetails.model != nil {
                print(transactionResponseDetails)
                transactionModel = transactionResponseDetails.model!
                async let getTransactionReceipt = await getTransactionReceipt(forTxnRefNumber: txnRefNumber)
                transactionModel.linklyTransaction.receipts = try await getTransactionReceipt
                transactionModel.linklyTransaction.sessionId = sessionID
            }
            return (transactionResponseDetails.statusCode, transactionModel)
        } catch {
            throw error
        }
    }
    
    public func checkTransactionStatus(forSessionID sessionID: String,
                                       andTxnRefNumber txnRefNumber: String
    ) async throws -> (Int, LinklyTransaction) {
        var transactionModel = demoTransactionModel
        do {
            async let getTransactionResponse = transactionControl.getTransactionStatus(forSessionID: sessionID)
            let transactionResponseDetails = try await getTransactionResponse
            if (transactionResponseDetails.statusCode == 200 || transactionResponseDetails.statusCode == 201) && transactionResponseDetails.model != nil {
                print(transactionResponseDetails)
                transactionModel = transactionResponseDetails.model!
            }
            return (transactionResponseDetails.statusCode, transactionModel.linklyTransaction)
        } catch {
            throw error
        }
    }
}


//
//  Interaction.swift
//
//
//  Created by Miamedia Developer on 01/10/24.
//

import Foundation
import Logger
import Network
import SwiftUI
import DesignSystem

class LinklyConfiguration: ObservableObject {
    let logger: Logger
    let apiClientService: APIClientService
    
    init(logger: Logger,
         apiClientService: APIClientService
    ) {
        self.logger = logger
        self.apiClientService = apiClientService
    }
}

class AuthConfiguration: ObservableObject {
    let configuration: LinklyConfiguration
    
    init(isProductionMode prodMode: Bool) {
        let logger = Logger(label: "Qiki POS")
        print(logger)

        var apiClientService = APIClientService(logger: logger,
                                                configuration: .init(baseURL: URL(string: "https://auth.sandbox.cloud.pceftpos.com"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(logger: logger,
                                                    configuration: .init(baseURL: URL(string: "https://auth.cloud.pceftpos.com"),
                                                                         baseHeaders: ["Accept": "application/json",
                                                                                       "content-type": "application/json"
                                                                                      ]
                                                                        )
            )
        }
        
        configuration = .init(logger: logger,
                              apiClientService: apiClientService
        )
    }
}

final public class Pairing: ObservableObject {
    var terminalPairing: TerminalPairing
    
    public init(isProductionMode mode: Bool) {
        self.terminalPairing = TerminalPairing.init(apiClientService: AuthConfiguration.init(isProductionMode: mode).configuration.apiClientService)
    }
    
    public func initiatePairing(withTerminalNumber terminalNumber: String,
                                   andUsername username: String,
                                   andPassword password: String,
                                   andPairingCode pairCode: String,
                                   forPOS posName: String,
                                   andPOSVersion posVersion: String,
                                   andPOSID posID: String,
                                   andPOSVendorID vendorID: String
    ) async -> TokenDetails {
        async let getAuthSecret = terminalPairing.pairTerminal(withTerminalNumber: terminalNumber,
                                                               andUsername: username,
                                                               andPassword: password,
                                                               andPairingCode: pairCode
        )
        
        guard let authSecretDetails = try? await getAuthSecret else {
            return TokenDetails(authSecret: "",
                                authToken: "",
                                tokenExpiryTime: 0
            )
        }
        print(authSecretDetails)
        
        guard authSecretDetails.terminalSecret != "" else {
            print("Unable to get auth secret details... Hence, I am returning back.")
            return TokenDetails(authSecret: "",
                                authToken: "",
                                tokenExpiryTime: 0
            )
        }
        
        async let tokenDetails = getLinklyAuthToken(withSecret: authSecretDetails.terminalSecret,
                                                    forPOS: posName,
                                                    andPOSVersion: posVersion,
                                                    andPOSID: posID,
                                                    andPOSVendorID: vendorID
        )
        
        return await tokenDetails
    }
    
    public func getLinklyAuthToken(withSecret secret: String,
                                   forPOS posName: String,
                                   andPOSVersion posVersion: String,
                                   andPOSID posID: String,
                                   andPOSVendorID vendorID: String
    ) async -> TokenDetails {
        async let getAuthToken = terminalPairing.getAuthToken(withSecret: secret,
                                                              forPOS: posName,
                                                              andPOSVersion: posVersion,
                                                              andPOSID: posID,
                                                              andPOSVendorID: vendorID
        )
            
        guard let authTokenDetails = try? await getAuthToken else {
            print("Unable to get auth token details... Hence, I am returning back.")
            return TokenDetails(authSecret: "",
                                authToken: "",
                                tokenExpiryTime: 0
            )
        }
            
        print(authTokenDetails)
        authSecret = secret
        authToken = authTokenDetails.token
        tokenExpiryTime = authTokenDetails.expirySeconds
        
        return TokenDetails(authSecret: authSecret,
                            authToken: authToken,
                            tokenExpiryTime: tokenExpiryTime
        )
    }
}

class LinklyTransactionConfiguration: ObservableObject {
    let logger: Logger
    let apiClientService: APIClientService
    
    init(logger: Logger,
         apiClientService: APIClientService
    ) {
        self.logger = logger
        self.apiClientService = apiClientService
    }
}

class TransactionConfiguration: ObservableObject {
    let configuration: LinklyTransactionConfiguration
    
    init(isProductionMode prodMode: Bool) {
        let logger = Logger(label: "Qiki POS")
        print(logger)

        var apiClientService = APIClientService(logger: logger,
                                                configuration: .init(baseURL: URL(string: "https://rest.pos.sandbox.cloud.pceftpos.com"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(logger: logger,
                                                    configuration: .init(baseURL: URL(string: "https://rest.pos.cloud.pceftpos.com"),
                                                                         baseHeaders: ["Accept": "application/json",
                                                                                       "content-type": "application/json"
                                                                                      ]
                                                                        )
            )
        }
        
        configuration = .init(logger: logger,
                              apiClientService: apiClientService
        )
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
    public func checkPinpadStatus(withSessionId sessionId: String) async -> TerminalStatus {
        async let checkPinpadStatus = transactionControl.checkTerminalStatus(withSessionID: sessionId)
            
        guard let pinpadStatus = try? await checkPinpadStatus else {
            print("Unable to check connection between Pinpad and POS. Hence, I am returning back.")
            return TerminalStatus(sessionID: sessionId,
                                  responseType: "",
                                  response: TerminalStatusDetails.init(merchant: "",
                                                                       nii: 0,
                                                                       catid: "",
                                                                       caid: "",
                                                                       timeout: 0,
                                                                       loggedOn: false,
                                                                       pinPadSerialNumber: "",
                                                                       pinPadVersion: "",
                                                                       bankCode: "",
                                                                       bankDescription: "",
                                                                       kvc: "",
                                                                       safCount: 0,
                                                                       networkType: "",
                                                                       hardwareSerial: "",
                                                                       retailerName: "",
                                                                       optionsFlags: ["optionsFlags": false],
                                                                       safCreditLimit: 0,
                                                                       safDebitLimit: 0,
                                                                       maxSAF: 0,
                                                                       keyHandlingScheme: "",
                                                                       cashoutLimit: 0,
                                                                       refundLimit: 0,
                                                                       cpatVersion: "",
                                                                       nameTableVersion: "",
                                                                       terminalCommsType: "",
                                                                       cardMisreadCount: 0,
                                                                       totalMemoryInTerminal: 0,
                                                                       freeMemoryInTerminal: 0,
                                                                       eftTerminalType: "",
                                                                       numAppsInTerminal: 0,
                                                                       numLinesOnDisplay: 0,
                                                                       hardwareInceptionDate: "",
                                                                       success: false,
                                                                       responseCode: "",
                                                                       responseText: "Failed"
                                                                      )
            )
        }
        print(pinpadStatus)

        return pinpadStatus
    }

    public func initiatePaymentWithLinkly(withSessionId sessionId: String,
                                          forPurchaseAmount amount: String,
                                          andTxnRefNumber txnRefNumber: String
    ) async -> TransactionModel {
        async let getTransactionResponse = transactionControl.initiateTransaction(withSessionID: sessionId,
                                                                                  andMerchant: "00",
                                                                                  withTxnType: "P",
                                                                                  forPurchaseAmount: amount,
                                                                                  withTxnRefNumber: txnRefNumber,
                                                                                  andCurrencyCode: "AUD",
                                                                                  withCutReceiptOption: "0",
                                                                                  onApplication: "00",
                                                                                  withTipEnabled: 1,
                                                                                  andShouldAutoPrintReceipt: "7",
                                                                                  andPurchaseAnalysisData: ["AMT": amount,
                                                                                                            "PCM": "0000"] as [String: Any]
        )
        
        guard var transactionResponseDetails = try? await getTransactionResponse else {
            print("Transaction declined...")
            return demoTransactionModel
        }
        
        print(transactionResponseDetails)
        
        async let getTransactionReceipt = await getTransactionReceipt(forTxnRefNumber: txnRefNumber)
        transactionResponseDetails.linklyTransaction.receipts = await getTransactionReceipt
        
        return transactionResponseDetails
    }
    
    public func refundPaymentWithLinkly(withSessionId sessionId: String,
                                        forRefundAmount amount: String,
                                        andTxnRefNumber txnRefNumber: String
    ) async -> Refund {
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
        
        guard var refundResponseDetails = try? await getRefundResponse else {
            print("Refund declined...")
            return demoRefundModel
        }
        
        print(refundResponseDetails)
        
        async let getRefundReceipt = await getTransactionReceipt(forTxnRefNumber: txnRefNumber)
        refundResponseDetails.linklyRefund.receipts = await getRefundReceipt
        
        return refundResponseDetails
        
    }
    
    public func cancelPaymentWithLinkly(withSessionId sessionId: String,
                                        andTxnRefNumber txnRefNumber: String
    ) async -> String {
        async let getTransactionResponse = transactionControl.cancelTransaction(forSessionID: sessionId)
        
        guard let transactionResponseDetails = try? await getTransactionResponse else {
            print("Transaction cancellation request got failed...")
            return "Failed"
        }
        
        print(transactionResponseDetails)
        guard transactionResponseDetails.response != "" else {
            return "Ok"
        }
        
        return transactionResponseDetails.response!
    }
    
    public func getTransactionReceipt(forTxnRefNumber txnRefNumber: String) async -> [LinklyTransactionReceipts] {
        var linklyReceipts = [LinklyTransactionReceipts]()
        async let getTransctionReceiptResponse = transactionControl.getTransactionReceipts(withSessionID: generateSessionID(),
                                                                                           andMerchant: "00",
                                                                                           withTxnRefNumber: txnRefNumber,
                                                                                           onApplication: "00",
                                                                                           andShouldAutoPrintReceipt: "7",
                                                                                           andReceiptReprintType: "1"
        )
        
        guard let transactionReceiptResponseDetails  = try? await getTransctionReceiptResponse else {
            print("Unable to get transaction receipts...")
            return linklyReceipts
        }
        
        //Get receipt for transaction. Only merchant receipt will be received in response
        //If response fails, then return the transaction model response without receipt(s)
        let receiptText = LinklyTransactionReceipts(type: transactionReceiptResponseDetails.response.responseText,
                                                    receiptText: transactionReceiptResponseDetails.response.receiptText
        )
        linklyReceipts.append(receiptText)
        
        //Get the receipt updated for merchant
        var receiptTextToUpdate = receiptText.receiptText.joined(separator: ",")
        receiptTextToUpdate = receiptTextToUpdate.replacingOccurrences(of: "MERCHANT",
                                                                       with: "CUSTOMER"
        )
        
        let updatedReceipt = LinklyTransactionReceipts(type: transactionReceiptResponseDetails.response.responseText,
                                                       receiptText: receiptTextToUpdate.components(separatedBy: ",")
        )
        linklyReceipts.append(updatedReceipt)
        
        return linklyReceipts
    }
}

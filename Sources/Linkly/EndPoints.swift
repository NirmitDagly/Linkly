//
//  File.swift
//  
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network
import Logger

class APIEndPoints {
    
    static func initiatePairing(withTerminalNumber terminalNumber: String,
                                andUsername username: String,
                                andPassword password: String,
                                andPairingCode pairCode: String
    ) -> APIEndpoint {
        return .init(
            path: "/v1/pairing/cloudpos",
            httpMethod: .post,
            bodyParameter: .dictionary(
                [
                    "username" : username,
                    "password" : password,
                    "pairCode": pairCode
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func getAuthToken(withSecret secret: String,
                             forPOS posName: String,
                             andPOSVersion posVersion: String,
                             andPOSID posID: String,
                             andPOSVendorID vendorID: String
    ) -> APIEndpoint {
        return .init(
            path: "/v1/tokens/cloudpos",
            httpMethod: .post,
            bodyParameter: .dictionary(
                [
                    "secret" : secret,
                    "posName" : posName,
                    "posVersion": posVersion,
                    "posId": posID,
                    "posVendorID": vendorID
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func checkTerminalStatus(withSessionID sessionID: String) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/status?async=false",
            httpMethod: .post,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request" : [
                        "merchant": "00",
                        "application": "00",
                        "statusType": "0"
                    ] as [String: Any]
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func logonToPinpad(withSessionID sessionID: String) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/logon?async=false",
            httpMethod: .get,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request" : [
                        "merchant": "00",
                        "logonType": " ",
                        "application": "00",
                        "receiptAutoPrint": "0",
                        "cutReceipt": "0"
                    ]
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func initiateTransaction(withSessionID sessionID: String,
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
    ) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/transaction?async=false",
            httpMethod: .post,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request": [
                        "Merchant": merchant,
                        "TxnType": txnType,
                        "AmtPurchase": amount,
                        "TxnRef": txnRefNumber,
                        "CurrencyCode": currencyCode,
                        "CutReceipt": cutReceipt,
                        "Application": application,
                        "EnableTip": enableTip,
                        "ReceiptAutoPrint": autoPrintReceipt,
                        "PurchaseAnalysisData": purchaseAnalysisData
                    ]
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func cancelTransaction(forSessionID sessionID: String) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/sendkey?async=false",
            httpMethod: .post,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request": [
                        "key": "0",
                        "data": ""
                    ]
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func initiateRefund(withSessionID sessionID: String,
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
    ) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/transaction?async=false",
            httpMethod: .post,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request": [
                        "Merchant": merchant,
                        "TxnType": txnType,
                        "AmtPurchase": amount,
                        "TxnRef": txnRefNumber,
                        "CurrencyCode": currencyCode,
                        "CutReceipt": cutReceipt,
                        "Application": application,
                        "ReceiptAutoPrint": autoPrintReceipt,
                        "PurchaseAnalysisData": purchaseAnalysisData
                    ]
                ],
                options: .prettyPrinted
            )
        )
    }
    
    static func getTransactionStatus(forSessionID sessionID: String) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/transaction",
            httpMethod: .get,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary([:],
                                       options: .prettyPrinted
                                      )
        )
    }
    
    static func getTransactionReceipt(withSessionID sessionID: String,
                                      andMerchant merchant: String,
                                      withTxnRefNumber txnRefNumber: String,
                                      onApplication application: String,
                                      andShouldAutoPrintReceipt autoPrintReceipt: String,
                                      andReceiptReprintType reprintType: String
    ) -> APIEndpoint {
        return .init(
            path: "\(sessionID)/ReprintReceipt?async=false",
            httpMethod: .post,
            headers: [
                "Authorization": "Bearer \(authToken)"
            ],
            bodyParameter: .dictionary(
                [
                    "Request": [
                        "Merchant": merchant,
                        "OriginalTxnRef": txnRefNumber,
                        "Application": application,
                        "ReceiptAutoPrint": autoPrintReceipt,
                        "ReprintType": reprintType
                    ]
                ],
                options: .prettyPrinted
            )
        )
    }
}

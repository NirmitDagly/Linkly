//
//  File.swift
//  
//
//  Created by Miamedia Developer on 01/10/24.
//

import Foundation

//Linkly Access Token Timer
var refreshLinklyAccessTokenTimer: Timer?

var authSecret = ""

var authToken = ""

var tokenExpiryTime = 0.00

var demoTransactionModel = TransactionModel(linklyTransactionSessionID: "",
                                            linklyTransactionType: "P",
                                            linklyTransaction: LinklyTransaction(sessionId: "",
                                                                                 txnType: "",
                                                                                 merchant: "",
                                                                                 cardType: "",
                                                                                 cardName: "",
                                                                                 rrn: "",
                                                                                 dateSettlement: "",
                                                                                 amtCash: 0,
                                                                                 amtPurchase: 0,
                                                                                 amtTip: 0,
                                                                                 authCode: 0,
                                                                                 txnRef: "",
                                                                                 pan: "",
                                                                                 dateExpiry: "",
                                                                                 track2: "",
                                                                                 accountType: "",
                                                                                 balanceReceived: false,
                                                                                 availableBalance: 0,
                                                                                 clearedFundsBalance: 0,
                                                                                 success: false,
                                                                                 responseCode: "",
                                                                                 responseText: "",
                                                                                 date: "",
                                                                                 catID: "",
                                                                                 caID: "",
                                                                                 stan: 0,
                                                                                 txnFlags: .init(offline: "",
                                                                                                 receiptPrinted: "",
                                                                                                 cardEntry: "",
                                                                                                 commsMethod: "",
                                                                                                 currency: "",
                                                                                                 payPass: "",
                                                                                                 undefinedFlag6: "",
                                                                                                 undefinedFlag7: ""
                                                                                                ),
                                                                                 purchaseAnalysisData: PurchaseAnalysisData(rfn: "",
                                                                                                                            ref: "",
                                                                                                                            hrc: "",
                                                                                                                            hrt: "",
                                                                                                                            sur: "",
                                                                                                                            amt: "",
                                                                                                                            cem: ""
                                                                                                                           ),
                                                                                 receipts: [LinklyTransactionReceipts]()
                                                                                )
)

var demoRefundModel = Refund(linklyRefundSessionID: "",
                             linklyRefundResponseType: "R",
                             linklyRefund: LinklyTransaction(sessionId: "",
                                                             txnType: "",
                                                             merchant: "",
                                                             cardType: "",
                                                             cardName: "",
                                                             rrn: "",
                                                             dateSettlement: "",
                                                             amtCash: 0,
                                                             amtPurchase: 0,
                                                             amtTip: 0,
                                                             authCode: 0,
                                                             txnRef: "",
                                                             pan: "",
                                                             dateExpiry: "",
                                                             track2: "",
                                                             accountType: "",
                                                             balanceReceived: false,
                                                             availableBalance: 0,
                                                             clearedFundsBalance: 0,
                                                             success: false,
                                                             responseCode: "",
                                                             responseText: "",
                                                             date: "",
                                                             catID: "",
                                                             caID: "",
                                                             stan: 0,
                                                             txnFlags: .init(offline: "",
                                                                             receiptPrinted: "",
                                                                             cardEntry: "",
                                                                             commsMethod: "",
                                                                             currency: "",
                                                                             payPass: "",
                                                                             undefinedFlag6: "",
                                                                             undefinedFlag7: ""
                                                                            ),
                                                             purchaseAnalysisData: PurchaseAnalysisData(rfn: "",
                                                                                                        ref: "",
                                                                                                        hrc: "",
                                                                                                        hrt: "",
                                                                                                        sur: "",
                                                                                                        amt: "",
                                                                                                        cem: ""
                                                                                                       ),
                                                             receipts: [LinklyTransactionReceipts]()
                                                            )
)

var transactionProgressTimer: Timer?

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

var demoTerminalStatus = TerminalStatus(sessionID: "",
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

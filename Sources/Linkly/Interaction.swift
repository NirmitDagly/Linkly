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
    
    public func getLinklyAuthToken(withTerminalNumber terminalNumber: String,
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
        
        async let getAuthToken = terminalPairing.getAuthToken(withSecret: authSecretDetails.terminalSecret!,
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
        authSecret = authSecretDetails.terminalSecret!
        authToken = authTokenDetails.token
        tokenExpiryTime = authTokenDetails.expirySeconds
        
        return TokenDetails(authSecret: authSecret,
                            authToken: authToken,
                            tokenExpiryTime: tokenExpiryTime
        )
    }
}

class TransactionConfiguration: ObservableObject {
    let configuration: LinklyConfiguration
    
    init(isProductionMode prodMode: Bool) {
        let logger = Logger(label: "Qiki POS")
        print(logger)

        var apiClientService = APIClientService(logger: logger,
                                                configuration: .init(baseURL: URL(string: "https://rest.pos.sandbox.cloud.pceftpos.com/v1/sessions/"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(logger: logger,
                                                    configuration: .init(baseURL: URL(string: "https://rest.pos.cloud.pceftpos.com/v1/sessions/"),
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
    let transactionRepository: TransactionControl
    
    init(repository: TransactionControl,
         isProductionMode mode: Bool
    ) {
        self.transactionRepository = TransactionControl.init(apiClientService: TransactionConfiguration(isProductionMode: mode).configuration.apiClientService)
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

    public func initiatePaymentWithLinkly(forPurchaseAmount amount: String) async -> String {
        async let getTransactionResponse = transactionRepository.initiateTransaction(withSessionID: generateSessionID(),
                                                                                     andMerchant: "00",
                                                                                     withTxnType: "P",
                                                                                     forPurchaseAmount: amount,
                                                                                     withTxnRefNumber: getTransactionReferenceNumber(),
                                                                                     andCurrencyCode: "AUD",
                                                                                     withCutReceiptOption: "0",
                                                                                     onApplication: "00",
                                                                                     withTipEnabled: 1,
                                                                                     andShouldAutoPrintReceipt: "7",
                                                                                     andPurchaseAnalysisData: ["AMT": amount,
                                                                                                               "PCM": "0000"] as [String: Any]
        )
        
        guard let transactionResponseDetails = try? await getTransactionResponse else {
            print("Transaction declined...")
            return "This is test message..."
        }
        
        print(transactionResponseDetails)
        return "Approved"
    }
}

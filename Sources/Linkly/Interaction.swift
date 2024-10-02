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
                                                configuration: .init(baseURL: URL(string: "https://auth.sandbox.cloud.pceftpos.com/v1/"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(logger: logger,
                                                    configuration: .init(baseURL: URL(string: "https://auth.cloud.pceftpos.com/v1/"),
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

class Pairing: ObservableObject {
    let terminalRepository: TerminalPairing
    
    init(repository: TerminalOperationRepository,
         isProductionMode mode: Bool
    ) {
        self.terminalRepository = TerminalPairing.init(apiClientService: AuthConfiguration.init(isProductionMode: mode).configuration.apiClientService)
    }
    
    public func startPairing(withTerminalNumber terminalNumber: String,
                             andUsername username: String,
                             andPassword password: String,
                             andPairingCode pairCode: String
    ) async {
        async let getAuthSecret = terminalRepository.pairTerminal(withTerminalNumber: terminalNumber,
                                                                  andUsername: username,
                                                                  andPassword: password,
                                                                  andPairingCode: pairCode
        )
        
        guard let authSecretDetails = try? await getAuthSecret else {
            return
        }
        print(authSecretDetails)
        
        Task {
            await getLinklyAuthToken(withSecret: authSecretDetails.terminalSecret!,
                                     forPOS: "Admin",
                                     andPOSVersion: "1.0",
                                     andPOSID: UIDevice.current.identifierForVendor!.uuidString.lowercased() as String,
                                     andPOSVendorID: "QIKI"
            )
        }
    }
    
    public func getLinklyAuthToken(withSecret secret: String,
                                   forPOS posName: String,
                                   andPOSVersion posVersion: String,
                                   andPOSID posID: String,
                                   andPOSVendorID vendorID: String
    ) async -> TokenDetails {
        async let getAuthToken = terminalRepository.getAuthToken(withSecret: secret,
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
        
        return TokenDetails(authSecret: authSecret,
                            authToken: authToken,
                            tokenExpiryTime: authTokenDetails.expirySeconds
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

class TransactionInteraction: ObservableObject {
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

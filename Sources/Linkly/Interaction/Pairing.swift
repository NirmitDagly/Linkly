//
//  Pairing.swift
//  Linkly
//
//  Created by Miamedia on 11/6/2026.
//

import Foundation
import Logger
import HTTPNetwork
import SwiftUI
import DesignSystem

public class LinklyConfiguration: ObservableObject {
    let apiClientService: APIClientService
    
    init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
}

public class AuthConfiguration: ObservableObject {
    let configuration: LinklyConfiguration
    
    init(isProductionMode prodMode: Bool) {
        var apiClientService = APIClientService(configuration: .init(baseURL: URL(string: "https://auth.sandbox.cloud.pceftpos.com"),
                                                                     baseHeaders: ["Accept": "application/json",
                                                                                   "content-type": "application/json"
                                                                                  ]
                                                                    )
        )

        if prodMode == true {
            apiClientService = APIClientService(configuration: .init(baseURL: URL(string: "https://auth.cloud.pceftpos.com"),
                                                                         baseHeaders: ["Accept": "application/json",
                                                                                       "content-type": "application/json"
                                                                                      ]
                                                                        )
            )
        }
        
        configuration = .init(apiClientService: apiClientService)
    }
}

final public class Pairing: ObservableObject {
    var terminalPairing: TerminalPairing
    
    public init(authConfiguration: AuthConfiguration) {
        self.terminalPairing = TerminalPairing.init(apiClientService: authConfiguration.configuration.apiClientService)
    }
    
    public func initiatePairing(withTerminalNumber terminalNumber: String,
                                   andUsername username: String,
                                   andPassword password: String,
                                   andPairingCode pairCode: String,
                                   forPOS posName: String,
                                   andPOSVersion posVersion: String,
                                   andPOSID posID: String,
                                   andPOSVendorID vendorID: String
    ) async throws -> TokenDetails {
        do {
            async let getAuthSecret = terminalPairing.pairTerminal(withTerminalNumber: terminalNumber,
                                                                   andUsername: username,
                                                                   andPassword: password,
                                                                   andPairingCode: pairCode
            )
            
            let authSecretDetails = try await getAuthSecret
            print(authSecretDetails)
            
            guard authSecretDetails.model != nil, authSecretDetails.model!.terminalSecret != "" else {
                print("Unable to get auth secret details... Hence, I am returning back.")
                return TokenDetails(authSecret: "",
                                    authToken: "",
                                    tokenExpiryTime: 0
                )
            }
            
            async let tokenDetails = getLinklyAuthToken(withSecret: authSecretDetails.model!.terminalSecret,
                                                        forPOS: posName,
                                                        andPOSVersion: posVersion,
                                                        andPOSID: posID,
                                                        andPOSVendorID: vendorID
            )
            return try await tokenDetails
        } catch {
            throw error
        }
    }
    
    public func getLinklyAuthToken(withSecret secret: String,
                                   forPOS posName: String,
                                   andPOSVersion posVersion: String,
                                   andPOSID posID: String,
                                   andPOSVendorID vendorID: String
    ) async throws -> TokenDetails {
        do {
            async let getAuthToken = terminalPairing.getAuthToken(withSecret: secret,
                                                                  forPOS: posName,
                                                                  andPOSVersion: posVersion,
                                                                  andPOSID: posID,
                                                                  andPOSVendorID: vendorID
            )
            let authTokenDetails = try await getAuthToken
            print(authTokenDetails)
            
            guard authTokenDetails.model != nil else {
                print("Unable to get auth token details... Hence, I am returning back.")
                return TokenDetails(authSecret: "",
                                    authToken: "",
                                    tokenExpiryTime: 0
                )
            }
            
            authSecret = secret
            authToken = authTokenDetails.model!.token
            tokenExpiryTime = authTokenDetails.model!.expirySeconds
            
            return TokenDetails(authSecret: authSecret,
                                authToken: authToken,
                                tokenExpiryTime: tokenExpiryTime
            )
        } catch {
            throw error
        }
    }
}

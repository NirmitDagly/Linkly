//
//  TerminalOperationRepositoryImpl.swift
//  Linkly
//
//  Created by Miamedia on 11/6/2026.
//

import Foundation
import SwiftUI
import HTTPNetwork
import Logger

public class TerminalPairing: TerminalOperationRepository {

    private let apiClientService: APIClientService

    public init(apiClientService: APIClientService) {
        self.apiClientService = apiClientService
    }
    
    public func pairTerminal(withTerminalNumber terminalNumber: String,
                             andUsername username: String,
                             andPassword password: String,
                             andPairingCode pairCode: String
    ) async throws -> DecodedResponse<PairingModel> {
        try await apiClientService.request(
            APIEndPoints.initiatePairing(withTerminalNumber: terminalNumber,
                                         andUsername: username,
                                         andPassword: password,
                                         andPairingCode: pairCode
                                        ),
            mapper: PairingResponseMapper()
        )
    }
    
    public func getAuthToken(withSecret secret: String,
                             forPOS posName: String,
                             andPOSVersion posVersion: String,
                             andPOSID posID: String,
                             andPOSVendorID vendorID: String
    ) async throws -> DecodedResponse<AuthTokenModel> {
        try await apiClientService.request(
            APIEndPoints.getAuthToken(withSecret: secret,
                                      forPOS: posName,
                                      andPOSVersion: posVersion,
                                      andPOSID: posID,
                                      andPOSVendorID: vendorID
                                     ),
            mapper: AuthTokenResponseMapper(),
            retryPolicy: DefaultAPIRetryPolicy()
        )
    }
}

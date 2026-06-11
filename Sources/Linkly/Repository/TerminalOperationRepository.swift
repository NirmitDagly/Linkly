//
//  TerminalOperationRepository.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import HTTPNetwork
import Logger

public protocol TerminalOperationRepository {
    
    func pairTerminal(withTerminalNumber terminalNumber: String,
                      andUsername username: String,
                      andPassword password: String,
                      andPairingCode pairCode: String
    ) async throws -> DecodedResponse<PairingModel>
    
    func getAuthToken(withSecret secret: String,
                      forPOS posName: String,
                      andPOSVersion posVersion: String,
                      andPOSID posID: String,
                      andPOSVendorID vendorID: String
    ) async throws -> DecodedResponse<AuthTokenModel>
    
}


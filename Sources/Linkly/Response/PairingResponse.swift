//
//  PairingResponse.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import Network

public struct PairingResponse: Codable {
    public let terminalSerialNumber: String
    public let terminalUserName: String
    public let terminalPassword: String
    public let terminalPairingCode: String?
    public let terminalSecret: String?

    enum CodingKeys: String, CodingKey {
        case terminalSerialNumber
        case terminalUserName
        case terminalPassword
        case terminalPairingCode
        case terminalSecret = "secret"
    }
}

struct PairingResponseMapper: Mappable {
    
    func map(_ input: PairingResponse) -> PairingModel {
        return .init(
            terminalSerialNumber: input.terminalSerialNumber,
            terminalUserName: input.terminalUserName,
            terminalPassword: input.terminalPassword,
            terminalPairingCode: input.terminalPairingCode,
            terminalSecret: input.terminalSecret
        )
    }
}

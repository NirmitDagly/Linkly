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
    public let terminalSecret: String

    enum CodingKeys: String, CodingKey {
        case terminalSecret = "secret"
    }
}

struct PairingResponseMapper: Mappable {
    
    func map(_ input: PairingResponse) -> PairingModel {
        return .init(
            terminalSecret: input.terminalSecret
        )
    }
}

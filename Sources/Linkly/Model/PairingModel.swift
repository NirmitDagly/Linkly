//
//  PairingModel.swift
//
//
//  Created by Miamedia Developer on 15/08/24.
//

import Foundation
import SwiftUI
import Network

public struct PairingModel: Codable {
    var terminalSerialNumber: String
    var terminalUserName: String
    var terminalPassword: String
    var terminalPairingCode: String?
    var terminalSecret: String?
}

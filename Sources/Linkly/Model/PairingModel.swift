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
    public var terminalSerialNumber: String
    public var terminalUserName: String
    public var terminalPassword: String
    public var terminalPairingCode: String?
    public var terminalSecret: String?
}

//
//  TerminalStatus.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct TerminalStatus: Codable {
    public var sessionID: String?
    public var responseType: String
    public var response: TerminalStatusDetails
}

// MARK: - Terminal Status Details
public struct TerminalStatusDetails: Codable {
    public let merchant: String
    public let nii: Int
    public let catid, caid: String
    public let timeout: Int
    public let loggedOn: Bool
    public let pinPadSerialNumber, pinPadVersion, bankCode, bankDescription: String
    public let kvc: String
    public let safCount: Int
    public let networkType, hardwareSerial, retailerName: String
    public let optionsFlags: [String: Bool]
    public let safCreditLimit, safDebitLimit, maxSAF: Int
    public let keyHandlingScheme: String
    public let cashoutLimit, refundLimit: Int
    public let cpatVersion, nameTableVersion, terminalCommsType: String
    public let cardMisreadCount, totalMemoryInTerminal, freeMemoryInTerminal: Int
    public let eftTerminalType: String
    public let numAppsInTerminal, numLinesOnDisplay: Int
    public let hardwareInceptionDate: String
    public let success: Bool
    public let responseCode, responseText: String
}

//
//  TerminalStatus.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

struct TerminalStatus: Codable {
    var sessionID: String?
    var responseType: String
    var response: TerminalStatusDetails
}

// MARK: - Terminal Status Details
struct TerminalStatusDetails: Codable {
    let merchant: String
    let nii: Int
    let catid, caid: String
    let timeout: Int
    let loggedOn: Bool
    let pinPadSerialNumber, pinPadVersion, bankCode, bankDescription: String
    let kvc: String
    let safCount: Int
    let networkType, hardwareSerial, retailerName: String
    let optionsFlags: [String: Bool]
    let safCreditLimit, safDebitLimit, maxSAF: Int
    let keyHandlingScheme: String
    let cashoutLimit, refundLimit: Int
    let cpatVersion, nameTableVersion, terminalCommsType: String
    let cardMisreadCount, totalMemoryInTerminal, freeMemoryInTerminal: Int
    let eftTerminalType: String
    let numAppsInTerminal, numLinesOnDisplay: Int
    let hardwareInceptionDate: String
    let success: Bool
    let responseCode, responseText: String
}

//
//  TerminalStatusResponse.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct TerminalStatusResponse: Codable {
    var sessionID: String?
    var responseType: String
    var response: TerminalStatusDetailsResponse

    enum CodingKeys: String, CodingKey {
        case sessionID = "sessionId"
        case responseType = "responseType"
        case response = "response"
    }
}

struct TerminalStatusResponseMapper: Mappable {
    func map(_ input: TerminalStatusResponse) throws -> TerminalStatus {
        return .init(sessionID: input.sessionID ?? "",
                     responseType: input.responseType,
                     response: try TerminalStatusDetailsResponseMapper().map(input.response))
    }
}

// MARK: - Terminal Status Details
struct TerminalStatusDetailsResponse: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case merchant = "merchant"
        //case aiic = "aiic"
        case nii = "nii"
        case catid = "catid"
        case caid = "caid"
        case timeout = "timeout"
        case loggedOn = "loggedOn"
        case pinPadSerialNumber = "pinPadSerialNumber"
        case pinPadVersion = "pinPadVersion"
        case bankCode = "bankCode"
        case bankDescription = "bankDescription"
        case kvc = "kvc"
        case safCount = "safCount"
        case networkType = "networkType"
        case hardwareSerial = "hardwareSerial"
        case retailerName = "retailerName"
        case optionsFlags = "optionsFlags"
        case safCreditLimit = "safCreditLimit"
        case safDebitLimit = "safDebitLimit"
        case maxSAF = "maxSAF"
        case keyHandlingScheme = "keyHandlingScheme"
        case cashoutLimit = "cashoutLimit"
        case refundLimit = "refundLimit"
        case cpatVersion = "cpatVersion"
        case nameTableVersion = "nameTableVersion"
        case terminalCommsType = "terminalCommsType"
        case cardMisreadCount = "cardMisreadCount"
        case totalMemoryInTerminal = "totalMemoryInTerminal"
        case freeMemoryInTerminal = "freeMemoryInTerminal"
        case eftTerminalType = "eftTerminalType"
        case numAppsInTerminal = "numAppsInTerminal"
        case numLinesOnDisplay = "numLinesOnDisplay"
        case hardwareInceptionDate = "hardwareInceptionDate"
        case success = "success"
        case responseCode = "responseCode"
        case responseText = "responseText"
    }
}

struct TerminalStatusDetailsResponseMapper: Mappable {
    
    func map(_ input: TerminalStatusDetailsResponse) throws -> TerminalStatusDetails {
        return .init(merchant: input.merchant,
                     nii: input.nii,
                     catid: input.catid,
                     caid: input.caid,
                     timeout: input.timeout,
                     loggedOn: input.loggedOn,
                     pinPadSerialNumber: input.pinPadSerialNumber,
                     pinPadVersion: input.pinPadVersion,
                     bankCode: input.bankCode,
                     bankDescription: input.bankDescription,
                     kvc: input.kvc,
                     safCount: input.safCount,
                     networkType: input.networkType,
                     hardwareSerial: input.hardwareSerial,
                     retailerName: input.retailerName,
                     optionsFlags: input.optionsFlags,
                     safCreditLimit: input.safCreditLimit,
                     safDebitLimit: input.safDebitLimit,
                     maxSAF: input.maxSAF,
                     keyHandlingScheme: input.keyHandlingScheme,
                     cashoutLimit: input.cashoutLimit,
                     refundLimit: input.refundLimit,
                     cpatVersion: input.cpatVersion,
                     nameTableVersion: input.nameTableVersion,
                     terminalCommsType: input.terminalCommsType,
                     cardMisreadCount: input.cardMisreadCount,
                     totalMemoryInTerminal: input.totalMemoryInTerminal,
                     freeMemoryInTerminal: input.freeMemoryInTerminal,
                     eftTerminalType: input.eftTerminalType,
                     numAppsInTerminal: input.numAppsInTerminal,
                     numLinesOnDisplay: input.numLinesOnDisplay,
                     hardwareInceptionDate: input.hardwareInceptionDate,
                     success: input.success,
                     responseCode: input.responseCode,
                     responseText: input.responseText
        )
    }
}

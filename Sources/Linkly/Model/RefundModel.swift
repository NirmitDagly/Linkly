//
//  Refund.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct Refund: Codable {
    var linklyRefundSessionID: String?
    var linklyRefundResponseType: String
    var linklyRefund: LinklyTransaction
}


//
//  Refund.swift
//
//
//  Created by Miamedia Developer on 19/08/24.
//

import Foundation
import Network

public struct Refund: Codable {
    public var linklyRefundSessionID: String?
    public var linklyRefundResponseType: String
    public var linklyRefund: LinklyTransaction
}


//
//  Cryptocurrency.swift
//  Returns
//
//  Created by James Chen on 2021/11/07.
//

import Foundation
import Money

// Do not forget to add new cryptocurrency symbol to CurrencySymbol.cache
// as they are not built-in.

enum BTC: CurrencyType {
    static var name: String { "Bitcoin" }
    static var code: String { "BTC" }
    static var minorUnit: Int { 8 }
    static let symbol = "₿"
}

enum ETH: CurrencyType {
    static var name: String { "Ethereum" }
    static var code: String { "ETH" }
    static var minorUnit: Int { 18 }
    static let symbol = "Ξ"
}

enum LTC: CurrencyType {
    static var name: String { "Litecoin" }
    static var code: String { "LTC" }
    static var minorUnit: Int { 8 }
    static let symbol = "Ł"
}


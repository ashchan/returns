//
//  CurrencySymbol.swift
//  Returns
//
//  Created by James Chen on 2021/11/06.
//

import Foundation

final class CurrencySymbol {
    // code: symbols
    private static var cached: [String: [String]] = {
        var cache: [String: [String]] = [
            BTC.code: [BTC.symbol],
            ETH.code: [ETH.symbol],
            LTC.code: [LTC.symbol]
        ]
        let currencyCodes = Set(Locale.commonISOCurrencyCodes)

        for locale in Locale.availableIdentifiers.map(Locale.init(identifier:)) {
            guard let currencyCode = locale.currencyCode, let currencySymbol = locale.currencySymbol else {
                continue
            }
            if currencyCodes.contains(currencyCode) {
                cache[currencyCode, default: []].insert(currencySymbol, at: 0)
            }
        }
        return cache
    }()

    static func symbol(for currencyCode: String) -> String {
        return (cached[currencyCode] ?? []).min { $0.count < $1.count } ?? ""
    }
}

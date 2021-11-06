//
//  CurrencySymbol.swift
//  Returns
//
//  Created by James Chen on 2021/11/06.
//

import Foundation

final class CurrencySymbol {
    static var shared = CurrencySymbol()
    var cached: [String: String] = [:]

    private init() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        for currency in Currency.allCurrencies {
            formatter.currencyCode = currency.id
            cached[currency.id] = formatter.currencySymbol
        }
    }

    func symbol(for currencyCode: String) -> String {
        return cached[currencyCode] ?? ""
    }
}

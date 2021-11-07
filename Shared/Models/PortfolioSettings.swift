//
//  PortfolioSettings.swift
//  Returns
//
//  Created by James Chen on 2021/11/07.
//

import Foundation

// TODO: change to CurrencySettings?
class PortfolioSettings: ObservableObject {
    @Published var currencyInputFormatter = NumberFormatter()
    @Published var currencyOutputFormatter = NumberFormatter()

    var portfolio: Portfolio? {
        didSet {
            updateCurrencyInputFormatter()
            updateCurrencyOutputFormatter()
        }
    }

    func updateCurrencyInputFormatter() {
        guard let currency = portfolio?.currency else {
            return
        }

        currencyInputFormatter.generatesDecimalNumbers = true
        currencyInputFormatter.currencyCode = currency.code
        currencyInputFormatter.currencySymbol = currency.symbol
        currencyInputFormatter.maximumFractionDigits = currency.minorUnit
        // currencyInputFormatter.minimumFractionDigits = 0
    }

    func updateCurrencyOutputFormatter() {
        guard let currency = portfolio?.currency else {
            return
        }

        currencyOutputFormatter.generatesDecimalNumbers = true
        currencyOutputFormatter.numberStyle = .currency
        currencyOutputFormatter.currencyCode = currency.code
        currencyOutputFormatter.currencySymbol = currency.symbol
        currencyOutputFormatter.maximumFractionDigits = currency.minorUnit
        // currencyOutputFormatter.minimumFractionDigits = 0
    }
}

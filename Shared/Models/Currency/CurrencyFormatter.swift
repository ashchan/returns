//
//  CurrencyFormatter.swift
//  Returns
//
//  Created by James Chen on 2021/11/07.
//

import Foundation

final class CurrencyFormatter {
    var inputFormatter = NumberFormatter()
    var outputFormatter = NumberFormatter()
    var outputNoFractionFormatter = NumberFormatter()
    var currency: Currency? {
        didSet {
            update()
        }
    }

    private func update() {
        updateInputFormatter()
        updateOutputFormatter()
        updateOutputNoFractionFormatter()
    }

    private func updateInputFormatter() {
        guard let currency = currency else {
            inputFormatter = NumberFormatter()
            inputFormatter.generatesDecimalNumbers = true
            return
        }

        inputFormatter.generatesDecimalNumbers = true
        inputFormatter.currencyCode = currency.code
        inputFormatter.currencySymbol = currency.symbol
        inputFormatter.maximumFractionDigits = currency.minorUnit
    }

    private func updateOutputFormatter() {
        guard let currency = currency else {
            outputFormatter = NumberFormatter()
            outputFormatter.generatesDecimalNumbers = true
            outputFormatter.numberStyle = .currency
            return
        }

        outputFormatter.generatesDecimalNumbers = true
        outputFormatter.numberStyle = .currency
        outputFormatter.currencyCode = currency.code
        outputFormatter.currencySymbol = currency.symbol
        outputFormatter.maximumFractionDigits = currency.minorUnit
    }

    private func updateOutputNoFractionFormatter() {
        guard let currency = currency else {
            outputNoFractionFormatter = NumberFormatter()
            outputNoFractionFormatter.generatesDecimalNumbers = true
            outputNoFractionFormatter.numberStyle = .currency
            return
        }

        outputNoFractionFormatter.generatesDecimalNumbers = true
        outputNoFractionFormatter.numberStyle = .currency
        outputNoFractionFormatter.currencyCode = currency.code
        outputNoFractionFormatter.currencySymbol = currency.symbol
        outputNoFractionFormatter.maximumFractionDigits = 0
    }
}

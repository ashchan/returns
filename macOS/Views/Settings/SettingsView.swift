//
//  Settings.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/06.
//

import SwiftUI

struct SettingsView: View {
    @State private var preferredCurrency = Currency.default

    var body: some View {
        Form {
            // TODO: show symbol along with currency name
            Picker("Preferred Currency:", selection: $preferredCurrency) {
                ForEach(Currency.popularCurrencies, id: \.self) { currency in
                    currencyItem(for: currency)
                }
                Divider()
                ForEach(Currency.otherCurrencies, id: \.self) { currency in
                    currencyItem(for: currency)
                }
            }
        }
        .padding(20)
        .frame(width: 800, height: 600)
    }

    private func currencyItem(for currency: Currency) -> some View {
        Text("\(currency.code) - \(currency.name) (\(symbol(for: currency.code)))")
    }

    private func symbol(for code: String) -> String {
        CurrencySymbol.symbol(for: code)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

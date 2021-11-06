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
                    Text("\(currency.name) (\(symbol(for: currency.id)))")
                }
                Divider()
                ForEach(Currency.otherCurrencies.sorted(by: { $0.name < $1.name }), id: \.self) { currency in
                    Text("\(currency.name) (\(symbol(for: currency.id)))")
                }
            }
        }
        .padding(20)
        .frame(width: 800, height: 600)
    }

    func symbol(for code: String) -> String {
        CurrencySymbol.shared.symbol(for: code)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

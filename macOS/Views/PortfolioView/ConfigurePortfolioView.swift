//
//  ConfigurePortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/05.
//

import SwiftUI

struct ConfigurePortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var currencyCode = ""

    // Parameters: currencyCode
    // TODO: other params
    var onSave: ((String) -> Void)?

    var body: some View {
        VStack {
            HStack {
                Text("Configure Portfolio")
                    .font(.title)
                Spacer()
            }

            Picker("Currency:", selection: $currencyCode) {
                Text("System Default").tag("")
                Divider()
                ForEach(Currency.popularCurrencies, id: \.self) { currency in
                    currencyItem(for: currency)
                }
                Divider()
                ForEach(Currency.cryptocurrencies, id: \.self) { currency in
                    currencyItem(for: currency)
                }
                Divider()
                ForEach(Currency.otherCurrencies, id: \.self) { currency in
                    currencyItem(for: currency)
                }
            }

            Spacer()

            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    dismiss()
                    onSave?(currencyCode)
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 400, height: 220)
    }
}

private extension ConfigurePortfolioView {
    private func currencyItem(for currency: Currency) -> some View {
        Text("\(currency.code) - \(currency.name) (\(symbol(for: currency.code)))")
            .tag(currency.code)
    }

    private func symbol(for code: String) -> String {
        CurrencySymbol.symbol(for: code)
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConfigurePortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurePortfolioView(currencyCode: "USD")
    }
}

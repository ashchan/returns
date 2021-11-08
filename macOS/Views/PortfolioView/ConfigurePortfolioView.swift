//
//  ConfigurePortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/05.
//

import SwiftUI

struct ConfigurePortfolioView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var config: PortfolioConfig

    var onSave: ((PortfolioConfig) -> Void)?

    private let dateFormatter = DateFormatter()

    var body: some View {
        VStack {
            HStack {
                Text("Configure Portfolio")
                    .font(.headline)
                Spacer()
            }

            HStack {
                Text("Start:")
                    .frame(minWidth: 80, alignment: .trailing)
                TextField(
                    "Year",
                    value: $config.startYear,
                    formatter: NumberFormatter()
                ) { began in
                    if !began {
                        validateYear()
                    }
                }
                .textFieldStyle(.roundedBorder)
                Picker("Start:", selection: $config.startMonth) {
                    ForEach(1 ..< 13) { month in
                        monthItem(for: month)
                    }
                }
                .labelsHidden()
            }

            HStack {
                Text("Currency:")
                    .frame(minWidth: 80, alignment: .trailing)
                Picker("Currency:", selection: $config.currencyCode) {
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
                .labelsHidden()
            }

            HStack {
                Text("Name:")
                    .frame(minWidth: 80, alignment: .trailing)
                TextField(
                    "Portfolio Name",
                    text: $config.name,
                    onEditingChanged: { began in
                        if !began {
                            validateName()
                        }
                    }
                )
                .textFieldStyle(.roundedBorder)
            }

            Spacer()

            HStack {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    validateYear()
                    validateName()
                    dismiss()
                    onSave?(config)
                }
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(20)
        .frame(width: 400, height: 200)
    }
}

private extension ConfigurePortfolioView {
    func monthItem(for month: Int) -> some View {
        Text(dateFormatter.standaloneMonthSymbols[month - 1]).tag(month)
    }

    func currencyItem(for currency: Currency) -> some View {
        Text("\(currency.code) - \(currency.name) (\(symbol(for: currency.code)))")
            .tag(currency.code)
    }

    func symbol(for code: String) -> String {
        CurrencySymbol.symbol(for: code)
    }

    func validateYear() {
        if config.startYear < 1900 || config.startYear > PortfolioConfig.currentYear {
            config.startYear = PortfolioConfig.defaultYear
        }
    }

    func validateName() {
        if config.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            config.name = "New Portfolio"
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct ConfigurePortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurePortfolioView(config: PortfolioConfig(startYear: 2021, startMonth: 1, currencyCode: ""))
    }
}

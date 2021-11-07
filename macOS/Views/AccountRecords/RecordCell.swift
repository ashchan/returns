//
//  RecordCell.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

// Cell that doesn't show anything nor allow editing.
struct NullCell: View {
    var color: Color? = Color("nullCellColor")

    var body: some View {
        HStack {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color ?? Color("nullCellColor"))
    }
}

struct DateCell: View {
    var date: String

    var body: some View {
        Text(date)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("readonlyCellColor"))
    }
}

struct BalanceCell: View {
    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @State var balance: NSDecimalNumber
    @State private var text: String = ""
    var onUpdate: (NSDecimalNumber) -> ()

    var body: some View {
        return TextField("", text: $text, onEditingChanged: { begin in
            if !begin {
                validate(newText: text)
            }
        })
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .padding(4)
            .onAppear {
                update(balance: balance)
            }
    }

    func update(balance: NSDecimalNumber) {
        self.balance = balance
        text = portfolioSettings.currencyOutputFormatter.string(from: balance) ?? portfolioSettings.currencyOutputFormatter.string(from: 0)!
    }

    func validate(newText: String) {
        let trimmed = newText
            .replacingOccurrences(of: portfolioSettings.currencyOutputFormatter.currencySymbol, with: "")
            .replacingOccurrences(of: portfolioSettings.currencyOutputFormatter.currencyGroupingSeparator, with: "")
            .replacingOccurrences(of: " ", with: "")
        if let newValue = portfolioSettings.currencyInputFormatter.number(from: trimmed) as? NSDecimalNumber {
            update(balance: newValue)
            onUpdate(newValue)
        } else {
            update(balance: balance)
        }
    }
}

struct NotesCell: View {
    @State var notes: String
    var onUpdate: (String) -> ()

    var body: some View {
        TextField("", text: $notes, onEditingChanged: { begin in
            if !begin {
                onUpdate(notes)
            }
        })
            .textFieldStyle(.plain)
            .padding(4)
    }
}

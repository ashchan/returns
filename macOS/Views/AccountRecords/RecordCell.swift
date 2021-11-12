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
            .padding(4)
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
        Group{
            TextField("", text: $text, onEditingChanged: { begin in
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
    }

    func update(balance: NSDecimalNumber) {
        self.balance = balance
        text = portfolioSettings.currencyFormatter.outputFormatter.string(from: balance) ?? portfolioSettings.currencyFormatter.outputFormatter.string(from: 0)!
    }

    func validate(newText: String) {
        let trimmed = newText
            .replacingOccurrences(of: portfolioSettings.currencyFormatter.outputFormatter.currencySymbol, with: "")
            .replacingOccurrences(of: portfolioSettings.currencyFormatter.outputFormatter.currencyGroupingSeparator, with: "")
            .replacingOccurrences(of: " ", with: "")
        if let newValue = portfolioSettings.currencyFormatter.inputFormatter.number(from: trimmed) as? NSDecimalNumber {
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

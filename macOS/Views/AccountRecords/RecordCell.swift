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
        text = Self.currencyFormatter.string(from: balance) ?? Self.currencyFormatter.string(from: 0)!
    }

    func validate(newText: String) {
        let trimmed = newText
            .replacingOccurrences(of: Self.currencyFormatter.currencySymbol, with: "")
            .replacingOccurrences(of: Self.currencyFormatter.currencyGroupingSeparator, with: "")
            .replacingOccurrences(of: " ", with: "")
        // TODO: Other trimming?
        if let newValue = Self.currencyInputFormatter.number(from: trimmed) as? NSDecimalNumber {
            update(balance: newValue)
            onUpdate(newValue)
        } else {
            update(balance: balance)
        }
    }

    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        // formatter.locale = Locale(identifier: "fr_FR") // TODO: set current locale or user selected one
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    static var currencyInputFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        // formatter.locale = Locale(identifier: "fr_FR") // TODO: set current locale or user selected one
        formatter.generatesDecimalNumbers = true
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
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

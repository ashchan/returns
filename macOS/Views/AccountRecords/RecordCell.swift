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
    var onUpdate: (NSDecimalNumber) -> ()

    var body: some View {
        TextField("", value: $balance, formatter: NumberFormatter(), onCommit:  {
            onUpdate(balance)
            // TODO
        })
            .textFieldStyle(.plain)
            .multilineTextAlignment(.trailing)
            .padding(4)
    }
}

struct NotesCell: View {
    @State var notes: String
    var onUpdate: (String) -> ()

    var body: some View {
        TextField("", text: $notes, onCommit:  {
            onUpdate(notes)
            // TODO
        })
            .textFieldStyle(.plain)
            .padding(4)
    }
}

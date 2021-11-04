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

struct MonthCell: View {
    @State var record: Record

    var body: some View {
        Text(record.monthString)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("readonlyCellColor"))
    }
}

struct DateCell: View {
    @State var record: Record

    var body: some View {
        Text(record.closeDateString)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("readonlyCellColor"))
    }
}

struct BalanceCell: View {
    var balance: NSDecimalNumber?

    var body: some View {
        Text((balance ?? 0).description)
    }
}

struct NotesCell: View {
    @State var record: Record

    var body: some View {
        Text(record.notes ?? "")
    }
}

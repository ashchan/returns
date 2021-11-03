//
//  RecordCell.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

struct EmptyCell: View {
    var body: some View {
        EmptyView()
    }
}

struct MonthCell: View {
    @State var record: Record

    var body: some View {
        Text(record.monthString)
    }
}

struct DateCell: View {
    @State var record: Record

    var body: some View {
        Text(record.closeDateString)
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

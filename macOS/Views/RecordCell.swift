//
//  RecordCell.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

class EmptyCell: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        NSColor.lightGray.setFill()
        dirtyRect.fill()
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

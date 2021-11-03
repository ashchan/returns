//
//  Record.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension Record {
    // Set timestamp to beginning of the month
    func touch(date: Date = Date()) {
        timestamp = date.startOfMonth
    }

    // Last day of the month to add the closing account balance
    var closeDate: Date {
        timestamp!.endOfMonth
    }

    var monthString: String {
        Self.monthFormatter.string(from: timestamp!)
    }

    var closeDateString: String {
        Self.closeDateFormatter.string(from: closeDate)
    }

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    static let closeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}

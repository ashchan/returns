//
//  Record.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation
import CoreData

class Record: NSManagedObject {
}

extension Record {
    // Set timestamp to beginning of the month
    func touch(date: Date = Date()) {
        timestamp = date.startOfMonth
    }

    // Last day of the month to add the closing account balance
    var closeDate: Date {
        (timestamp ?? Date()).endOfMonth
    }

    var monthString: String {
        Self.monthFormatter.string(from: timestamp ?? Date())
    }

    var closeDateString: String {
        Self.closeDateFormatter.string(from: closeDate)
    }

    var isClosingToday: Bool {
        Calendar.utc.isDate(Date(), inSameDayAs: closeDate)
    }

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.timeZone = .utc
        return formatter
    }()

    static let closeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .utc
        return formatter
    }()
}

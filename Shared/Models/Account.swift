//
//  Account.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension Account {
    // Records sorted by date, excluding those out of portfolio start...current date.
    var sortedRecords: [Record] {
        let firstMonth = firstRecordMonth
        let lastMonth = Date().startOfMonth
        let set = records as? Set<Record> ?? []
        return set
            .filter {
                $0.timestamp! >= firstMonth && $0.timestamp! <= lastMonth
            }
            .sorted {
                $0.timestamp! < $1.timestamp!
            }
    }

    // First record month is the month before portfolio start date, to keep
    // the opening balance for the portfolio account.
    private var firstRecordMonth: Date {
        guard let portfolio = portfolio else { return Date().startOfMonth }

        return Calendar.current.date(byAdding: .month, value: -1, to: portfolio.since.startOfMonth)!
    }

    func rebuildRecords() {
        if portfolio == nil {
            return
        }

        let existing = sortedRecords
        let end = Date().startOfMonth
        var month = firstRecordMonth
        while month <= end {
            // Check if record for this month aleady exists
            if !existing.contains(where: { $0.timestamp == month.startOfMonth }) {
                let record = Record(context: managedObjectContext!)
                record.touch(date: month)
                record.account = self
            }

            month = Calendar.current.date(byAdding: .month, value: 1, to: month)!
        }
    }
}

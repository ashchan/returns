//
//  Account.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension Account {
    var sortedRecords: [Record] {
        let set = records as? Set<Record> ?? []
        return set.sorted {
            $0.timestamp! < $1.timestamp!
        }
    }

    var balanceData: [Date: NSDecimalNumber] {
        sortedRecords.reduce(into: [Date: NSDecimalNumber]()) { result, record in
            result[record.closeDate] = record.balance ?? 0
        }
    }

    // TODO: scan and add missing monthly records
    func rebuildRecords() {
        guard let portfolio = portfolio else { return }

        let start = portfolio.since.startOfMonth
        let end = Date().startOfMonth
        var month = Calendar.current.date(byAdding: .month, value: -1, to: start)!
        while month <= end {
            // TODO: check if record for this month aleady exists
            let record = Record(context: managedObjectContext!)
            record.touch(date: month)
            record.account = self

            month = Calendar.current.date(byAdding: .month, value: 1, to: month)!
        }
    }
}

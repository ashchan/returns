//
//  Balance.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation
import SwiftUI

struct Balance {
    var closeDate: Date
    var contribution: Decimal
    var withdrawal: Decimal
    var balance: Decimal
}

extension Balance {
    static func +(lhs: Balance, rhs: Balance) -> Balance {
        assert(lhs.closeDate == rhs.closeDate)
        return Balance(
            closeDate: lhs.closeDate,
            contribution: lhs.contribution + rhs.contribution,
            withdrawal: lhs.withdrawal + rhs.withdrawal,
            balance: lhs.balance + rhs.balance
        )
    }

    func closeDate(_ date: Date) -> Balance {
        var copy = self
        copy.closeDate = date
        return copy
    }
}

extension Balance {
    static let zero = Balance(closeDate: Date(), contribution: 0, withdrawal: 0, balance: 0)
}

extension Record {
    var balanceData: Balance {
        Balance(
            closeDate: closeDate,
            contribution: contribution?.decimalValue ?? 0,
            withdrawal: withdrawal?.decimalValue ?? 0,
            balance: balance?.decimalValue ?? 0
        )
    }
}

extension Account {
    // Last month balance is excluded unless today is close day
    var balanceData: [Date: Balance] {
        var allRecords = sortedRecords
        if let last = allRecords.last, !last.isClosingToday {
            allRecords = allRecords.dropLast()
        }
        return allRecords.reduce(into: [Date: Balance]()) { result, record in
            result[record.closeDate] = record.balanceData
        }
    }

    // Balance on the most recent close date
    var currentBalance: Balance {
        let recordsCount = sortedRecords.count
        if recordsCount <= 1 {
            // Practically this should not happen
            return sortedRecords.last?.balanceData ?? Balance.zero
        } else if let record = sortedRecords.last, record.isClosingToday, record.balanceData.balance > 0 {
            return sortedRecords.last!.balanceData
        }
        return sortedRecords[recordsCount - 2].balanceData
    }
}

extension Portfolio {
    // Raw balance data, each as sum of accounts balances of the month.
    private var balanceData: [Date: Balance] {
        var result = [Date: Balance]()
        for accountBalances in sortedAccounts.map({ $0.balanceData }) {
            for balance in accountBalances {
                let value = result[balance.key] ?? Balance.zero.closeDate(balance.key)
                result[balance.key] = value + balance.value
            }
        }
        return result
    }

    var sortedBalanceData: [Balance] {
        balanceData.values.sorted {
            $0.closeDate < $1.closeDate
        }
    }
}

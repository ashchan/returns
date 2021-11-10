//
//  Balance.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

struct Balance {
    var closeDate: Date
    var contribution: Decimal
    var withdrawal: Decimal
    var balance: Decimal

    var flow: Decimal { contribution - withdrawal }
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
        Balance(
            closeDate: date,
            contribution: contribution,
            withdrawal: withdrawal,
            balance: balance
        )
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
    var balanceData: [Date: Balance] {
        sortedRecords.reduce(into: [Date: Balance]()) { result, record in
            result[record.closeDate] = record.balanceData
        }
    }
}

extension Portfolio {
    var balanceData: [Date: Balance] {
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

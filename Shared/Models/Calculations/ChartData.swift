//
//  ChartData.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

struct ChartData {
    let portfolio: Portfolio

    // Close date based balance values.
    var balanceData: [Double] {
        portfolio.sortedBalanceData.map { $0.balance.doubleValue }
    }

    // (Close date(timestamp), growth value)
    var growthData: [(Double, Double)] {
        portfolio.returns.map {
            ($0.closeDate.timeIntervalSince1970, $0.growth.doubleValue * 10_000)
        }
    }

    // Account based most recent month balance values on close date (account name, account balance).
    var totalAssetsData: [(String, Double)] {
        portfolio.sortedAccounts.map { account in
            (account.name ?? "", account.currentBalance.balance.doubleValue)
        }
    }

    var totalBalance: Double {
        portfolio.sortedAccounts
            .map { $0.currentBalance.balance.doubleValue }
            .reduce(0, +)
    }
}

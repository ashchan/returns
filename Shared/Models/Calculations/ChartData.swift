//
//  ChartData.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

struct ChartData {
    let portfolio: Portfolio

    // Close date based balance values
    var balanceData: [Double] {
        portfolio.sortedBalanceData.map { $0.balance.doubleValue }
    }

    // Account based balance values (account name: account balance)
    var totalAssetsData: [String: Double] {
        portfolio.sortedAccounts.reduce(into: [String: Double]()) { result, account in
            result[account.name ?? ""] = account.balanceData
                .map { $0.value.balance.doubleValue }
                .reduce(0, +)
        }
    }
}

//
//  ChartData.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

struct ChartData {
    let portfolio: Portfolio

    // Popluate data within [0...1]
    var balanceData: [Double] {
        let data = portfolio.sortedBalanceData.map { $0.balance.doubleValue }
        guard let max = data.max(), max > 0 else {
            return data
        }
        return data.map { $0 / max }
    }
}

//
//  ChartData.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

struct ChartData {
    let portfolio: Portfolio

    var balanceData: [Double] {
        portfolio.sortedBalanceData.map { $0.balance.doubleValue }
    }
}

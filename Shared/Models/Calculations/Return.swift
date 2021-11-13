//
//  Return.swift
//  Returns
//
//  Created by James Chen on 2021/11/13.
//

import Foundation

struct Return {
    var balance: Balance

    var closeDate: Date { balance.closeDate }
    var open: Decimal = 0 // Balance of previous month/record
    var flow: Decimal { balance.contribution - balance.withdrawal }
    var close: Decimal { balance.balance }
    var growth: Decimal = 1

    var threeMonthReturn: Decimal?
    var sixMonthReturn: Decimal?
}

// Modifier to set related data to calculate.
extension Return {
    func open(_ value: Decimal) -> Return {
        var copy = self
        copy.open = value
        return copy
    }

    // previous: previous month's growth
    func previousGrowth(_ previous: Decimal) -> Return {
        var copy = self
        copy.growth = previous + previous * self.oneMonthReturn
        return copy
    }

    func threeMonthReturn(_ value: Decimal?) -> Return {
        var copy = self
        copy.threeMonthReturn = value
        return copy
    }

    func sixMonthReturn(_ value: Decimal?) -> Return {
        var copy = self
        copy.sixMonthReturn = value
        return copy
    }
}

extension Return {
    var oneMonthReturn: Decimal {
        if (open + flow / 2).isZero {
            return 0
        }

        return (close - flow / 2) / (open + flow / 2) - 1
    }
}

extension Portfolio {
    // Month by month returns data
    var returns: [Return] {
        var results = sortedBalanceData.map { Return(balance: $0) }
        for index in 0 ..< results.count {
            // Set open date and pass in previous month growth to calculate current month growth
            if index > 0 {
                results[index] = results[index]
                    .open(results[index - 1].close)
                    .previousGrowth(results[index - 1].growth)
            } else {
                results[index].growth = 1
            }

            // Calcluate 3/6 months return
            let threeMonthReturn = index >= 3 ? results[index].growth / results[index - 3].growth - 1 : nil
            let sixMonthReturn = index >= 6 ? results[index].growth / results[index - 6].growth - 1 : nil
            results[index] = results[index]
                .threeMonthReturn(threeMonthReturn)
                .sixMonthReturn(sixMonthReturn)
        }
        return results
    }
}

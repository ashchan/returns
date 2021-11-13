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
    var ytdReturn: Decimal = 0
    var oneYearReturn: Decimal?
    var threeYearReturn: Decimal?
    var fiveYearReturn: Decimal?
    var tenYearReturn: Decimal?
    var fifteenYearReturn: Decimal?
    var twentyYearReturn: Decimal?
    var thirtyYearReturn: Decimal?
    var fiftyYearReturn: Decimal?
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
            var result = results[index]

            // Set open date and pass in previous month growth to calculate current month growth
            if index > 0 {
                result = result
                    .open(results[index - 1].close)
                    .previousGrowth(results[index - 1].growth)
            } else {
                result.growth = 1
            }

            // Calcluate 3/6 months, 1/3/5/10/15/20 years return
            result.threeMonthReturn = index >= 3 ? result.growth / results[index - 3].growth - 1 : nil
            result.sixMonthReturn = index >= 6 ? result.growth / results[index - 6].growth - 1 : nil
            result.oneYearReturn = index >= 12 ? result.growth / results[index - 12].growth - 1 : nil
            /* TODO: multiple year calculation
            result.threeYearReturn
            result.fiveYearReturn
            result.tenYearReturn
            result.fifteenYearReturn
            result.twentyYearReturn
            result.thirtyYearReturn
            result.fiftyYearReturn
             */

            // Calculate ytd return
            let month = result.closeDate.month
            var ytdReturn: Decimal = 0
            if index >= month {
                let yearStartGrowth = results[index - month].growth
                ytdReturn = yearStartGrowth.isZero ? 0 : result.growth / yearStartGrowth - 1
            }
            result.ytdReturn = ytdReturn

            results[index] = result
        }
        return results
    }
}

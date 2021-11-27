//
//  PortfolioBuilder.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/27.
//

import Foundation
import CoreData

struct PortfolioBuilder {
    static func createPortfolio(context: NSManagedObjectContext, config: PortfolioConfig? = nil) -> Portfolio {
        let portfolio = Portfolio(context: context)
        if let config = config {
            portfolio.update(config: config)
        } else {
            portfolio.name = "My Portfolio"
            var components = Calendar.current.dateComponents([.year], from: Date())
            components.month = 1
            portfolio.startAt = Calendar.current.date(from: components)!.startOfMonth
        }
        portfolio.createdAt = Date()

        let account = Account(context: context)
        account.createdAt = Date()
        account.name = "Account #1"
        account.portfolio = portfolio
        account.rebuildRecords()

        return portfolio
    }

    static func createAccount(context: NSManagedObjectContext, portfolio: Portfolio) -> Account {
        let account = Account(context: context)
        account.createdAt = Date()
        account.portfolio = portfolio
        account.name = "Account #\(portfolio.accounts?.count ?? 0 + 1)"
        account.rebuildRecords()

        return account
    }

    static func createSamplePortfolio(context: NSManagedObjectContext) -> Portfolio {
        let portfolio = Portfolio(context: context)
        portfolio.name = "Sample Portfolio"
        portfolio.createdAt = Date()
        portfolio.startAt = Calendar.current.date(byAdding: .month, value: 1 - sampleAccountRecordsData.count, to: Date())!.startOfMonth

        let account = Account(context: context)
        account.createdAt = Date()
        account.name = "Sample Account"
        account.portfolio = portfolio
        for (index, data) in sampleAccountRecordsData.enumerated() {
            let month = Calendar.current.date(byAdding: .month, value: index - 1, to: portfolio.startAt!)!
            let record = Record(context: context)
            record.touch(date: month)
            record.contribution = NSDecimalNumber(decimal: data[0])
            record.withdrawal = NSDecimalNumber(decimal: data[1])
            record.balance = NSDecimalNumber(decimal: data[2])
            record.account = account
        }
        account.rebuildRecords()

        return portfolio
    }

    static var sampleAccountRecordsData: [[Decimal]] {
        [
            [0,        0,        2_002_800],
            [0,        0,        2_143_500],
            [0,        20_000,   2_147_500],
            [0,        0,        2_129_900],
            [0,        0,        2_009_000],
            [0,        0,        2_126_600],
            [0,        0,        2_183_600],
            [0,        0,        2_306_700],
            [0,        0,        2_527_000],
            [0,        0,        2_572_300],
            [0,        0,        2_452_700],
            [0,        300_000,  2_147_200],
            [0,        0,        2_260_100],
            [0,        0,        2_290_400],
            [600_000,  0,        2_902_200],
            [0,        0,        2_935_202],
        ]
    }
}

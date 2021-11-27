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

    // TODO
    static func createSamplePortfolio(context: NSManagedObjectContext) -> Portfolio {
        let portfolio = Portfolio(context: context)
        portfolio.name = "Sample Portfolio"
        var components = Calendar.current.dateComponents([.year], from: Date())
        components.month = 1
        portfolio.startAt = Calendar.current.date(from: components)!.startOfMonth
        portfolio.createdAt = Date()

        let account = Account(context: context)
        account.createdAt = Date()
        account.name = "Sample Account #1"
        account.portfolio = portfolio
        account.rebuildRecords()

        return portfolio
    }
}

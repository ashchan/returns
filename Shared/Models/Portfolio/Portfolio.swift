//
//  Portfolio.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import Foundation
import CoreData

extension NSNotification.Name {
    static let portfolioDataUpdated = NSNotification.Name("portfolioDataUPdated")
}

extension Portfolio {
    var sortedAccounts: [Account] {
        let set = accounts as? Set<Account> ?? []
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }

    var since: Date { startAt ?? createdAt! }

    var sinceString: String {
        Self.monthFormatter.string(from: since)
    }

    var currency: Currency? {
        Currency.from(code: currencyCode ?? "")
    }

    func dataUpdated() {
        // TODO: if changes affect accounts (like start month/year change would
        //    rebuild all records), there should be no need for this.
        NotificationCenter.default.post(name: .portfolioDataUpdated, object: self)
    }

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
}

extension Portfolio {
    var balanceData: [NSDecimalNumber] {
        let accountsData = sortedAccounts.map({ $0.balanceData })
        let maxCount = accountsData.map({ $0.count }).max()!
        var result = [NSDecimalNumber](repeating: 0, count: maxCount)
        for index in 0 ..< maxCount + 1 {
            for accountData in accountsData {
                if accountData.count > index {
                    result[index] = result[index].adding(accountData[index])
                }
            }

        }
        return result
    }

    var balanceChartData: [Double] {
        let data = balanceData.map { $0.doubleValue }
        guard let max = data.max(), max > 0 else {
            return data
        }
        return data.map { $0 / max }
    }
}

// Create a new portfolio
// TODO: this is temporarily
extension Portfolio {
    class func createPortfolio(context: NSManagedObjectContext, config: PortfolioConfig? = nil) -> Portfolio {
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
}

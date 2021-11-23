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
    var tag: String {
        "portfolio-" + objectID.uriRepresentation().absoluteString
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

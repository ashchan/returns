//
//  Portfolio.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import Foundation
import CoreData

extension Portfolio {
    var sortedAccounts: [Account] {
        let set = accounts as? Set<Account> ?? []
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }

    var since: Date {
        let components = DateComponents(year: Int(startYear), month: Int(startMonth))
        return Calendar.current.date(from: components)!
    }
}

// Create a new portfolio
// TODO: this is temporarily
extension Portfolio {
    class func createPortfolio(context: NSManagedObjectContext) -> Portfolio {
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        portfolio.createdAt = Date()
        let components = Calendar.current.dateComponents([.year, .month], from: Date())
        portfolio.startYear = Int32(components.year!)
        portfolio.startMonth = 1 // Int32(components.month!)

        let account = Account(context: context)
        account.createdAt = Date()
        account.name = "Account #1"
        account.portfolio = portfolio
        account.rebuildRecords()

        return portfolio
    }
}

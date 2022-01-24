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

class Portfolio: NSManagedObject {
}

extension Portfolio {
    var sortedAccounts: [Account] {
        let set = accounts as? Set<Account> ?? []
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }

    var since: Date { startAt ?? Date() }

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

    func rebuildAccountRecords() {
        sortedAccounts.forEach { $0.rebuildRecords() }
    }

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.timeZone = .utc
        return formatter
    }()
}

extension Portfolio {
    var tag: String {
        "portfolio-" + objectID.uriRepresentation().absoluteString
    }
}

extension Portfolio: Encodable {
    enum CodingKeys: CodingKey {
        case name, currencyCode, startAt, createdAt, accounts
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(currencyCode, forKey: .currencyCode)
        try container.encode(startAt, forKey: .startAt)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(accounts as! Set<Account>, forKey: .accounts)
    }
}

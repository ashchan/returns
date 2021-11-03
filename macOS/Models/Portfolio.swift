//
//  Portfolio.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import Foundation

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

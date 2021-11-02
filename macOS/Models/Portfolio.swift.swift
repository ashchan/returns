//
//  Portfolio.swift.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import Foundation

extension Portfolio {
    public var sortedAccounts: [Account] {
        let set = accounts as? Set<Account> ?? []
        return set.sorted {
            $0.createdAt! < $1.createdAt!
        }
    }
}

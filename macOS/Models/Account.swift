//
//  Account.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension Account {
    var sortedRecords: [Record] {
        let set = records as? Set<Record> ?? []
        return set.sorted {
            $0.timestamp! < $1.timestamp!
        }
    }
}

//
//  NavigationItem.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/25.
//

import Foundation

struct NavigationItem {
    static let appStorageKeyLastItem = "lastNavigationItem"

    var tag = ""

    var isPortfolio: Bool {
        return tag.starts(with: "account-") || tag.starts(with: "portfolio-")
    }

    var accountUri: URL? {
        guard tag.starts(with: "account-") else { return nil }
        return URL(string: tag.replacingOccurrences(of: "account-", with: ""))
    }

    var portfolioUri: URL? {
        guard tag.starts(with: "portfolio-") else { return nil }
        let uriString = tag.replacingOccurrences(of: "portfolio-", with: "")
            .replacingOccurrences(of: "-overview", with: "")
            .replacingOccurrences(of: "-calculations", with: "")
        return URL(string: uriString)
    }
}

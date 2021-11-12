//
//  PortfolioConfig.swift
//  Returns
//
//  Created by James Chen on 2021/11/08.
//

import Foundation

// Plain object to represent portfolio properties.
struct PortfolioConfig {
    var name = "New Portfolio"
    var startYear = defaultYear
    var startMonth = 1
    var currencyCode = ""

    static func defaultConfig() -> PortfolioConfig {
        var config = PortfolioConfig()
        config.startYear = defaultYear
        return config
    }

    static var currentYear: Int {
        Calendar.current.dateComponents([.year], from: Date()).year!
    }

    static var defaultYear: Int {
        currentYear
    }
}

extension Portfolio {
    var config: PortfolioConfig {
        let components = Calendar.current.dateComponents([.year, .month], from: startAt!)
        return PortfolioConfig(
            name: name ?? "Portfolio",
            startYear: components.year!,
            startMonth: components.month!,
            currencyCode: currencyCode ?? ""
        )
    }

    func update(config: PortfolioConfig) {
        name = config.name
        let components = DateComponents(year: config.startYear, month: config.startMonth)
        startAt = Calendar.current.date(from: components)!.startOfMonth
        currencyCode = config.currencyCode

        // TODO: only rebuild if startAt has been changed
        sortedAccounts.forEach { $0.rebuildRecords() }
    }
}

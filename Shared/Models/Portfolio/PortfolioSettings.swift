//
//  PortfolioSettings.swift
//  Returns
//
//  Created by James Chen on 2021/11/07.
//

import Foundation

class PortfolioSettings: ObservableObject {
    let currencyFormatter = CurrencyFormatter()
    @Published var updatedAt = Date()

    var portfolio: Portfolio? {
        didSet {
            update()
        }
    }

    func update() {
        currencyFormatter.currency = portfolio?.currency
        updatedAt = Date()
    }
}

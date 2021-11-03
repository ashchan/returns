//
//  Date.swift
//  Returns
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }

    var month: Int {
        Calendar.current.component(.month, from: self)
    }

    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))
        return Calendar.current.date(from: components)!
    }

    var endOfMonth: Date {
        let components = DateComponents(month: 1, second: -1)
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}

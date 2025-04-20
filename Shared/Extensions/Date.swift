//
//  Date.swift
//  Returns
//
//  Created by James Chen on 2021/11/03.
//

import Foundation

extension TimeZone {
    static let utc = TimeZone(identifier: "UTC")!
}

extension Calendar {
    static let utc: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .utc
        return calendar
    }()
}

// Note the app assumes all record dates are stored in UTC time zone.
extension Date {
    var year: Int {
        Calendar.utc.component(.year, from: self)
    }

    var month: Int {
        Calendar.utc.component(.month, from: self)
    }

    var startOfMonth: Date {
        let components = Calendar.utc.dateComponents([.year, .month], from: Calendar.utc.startOfDay(for: self))
        return Calendar.utc.date(from: components)!
    }

    var endOfMonth: Date {
        let components = DateComponents(month: 1, second: -1)
        return Calendar.utc.date(byAdding: components, to: startOfMonth)!
    }
}

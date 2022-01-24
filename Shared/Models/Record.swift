//
//  Record.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import Foundation
import CoreData

class Record: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case timestamp, balance, contribution, withdrawal, notes
    }

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        balance = NSDecimalNumber(decimal: try container.decode(Decimal.self, forKey: .balance))
        contribution = NSDecimalNumber(decimal: try container.decode(Decimal.self, forKey: .contribution))
        withdrawal = NSDecimalNumber(decimal: try container.decode(Decimal.self, forKey: .withdrawal))
        notes = try container.decode(String?.self, forKey: .notes)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode((balance ?? 0).decimalValue, forKey: .balance)
        try container.encode((contribution ?? 0).decimalValue, forKey: .contribution)
        try container.encode((withdrawal ?? 0).decimalValue, forKey: .withdrawal)
        try container.encode(notes, forKey: .notes)
    }
}

extension Record {
    // Set timestamp to beginning of the month
    func touch(date: Date = Date()) {
        timestamp = date.startOfMonth
    }

    // Last day of the month to add the closing account balance
    var closeDate: Date {
        (timestamp ?? Date()).endOfMonth
    }

    var monthString: String {
        Self.monthFormatter.string(from: timestamp ?? Date())
    }

    var closeDateString: String {
        Self.closeDateFormatter.string(from: closeDate)
    }

    var isClosingToday: Bool {
        Calendar.utc.isDate(Date(), inSameDayAs: closeDate)
    }

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.timeZone = .utc
        return formatter
    }()

    static let closeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = .utc
        return formatter
    }()
}

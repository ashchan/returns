//
//  Decimal.swift
//  Returns
//
//  Created by James Chen on 2021/11/10.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        Double(truncating: self as NSNumber)
    }
}

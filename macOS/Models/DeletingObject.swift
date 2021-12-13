//
//  DeletingObject.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/12/07.
//

import Foundation

class DeletingObject: ObservableObject {
    @Published var deletingInfo: DeletingInfo?
}

struct DeletingInfo: Identifiable {
    enum ObjectType {
        case portfolio
        case account
    }

    let type: ObjectType
    let portfolio: Portfolio?
    let account: Account?

    var id: ObjectType { type }

    var title: String {
        if type == .portfolio {
            return portfolio!.name ?? ""
        } else {
            return account!.name ?? ""
        }
    }

    var message: String {
        if type == .portfolio {
            return NSLocalizedString("Are you sure you want to delete the portfolio?", comment: "")
        } else {
            return NSLocalizedString("Are you sure you want to delete the account?", comment: "")
        }
    }
}

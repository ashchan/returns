//
//  AccountRecordList.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/10/31.
//

import AppKit
import SwiftUI

struct AccountRecordList: NSViewControllerRepresentable {
    typealias NSViewControllerType = TableViewController

    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @ObservedObject var account: Account

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSViewController(context: Context) -> TableViewController {
        let controller = TableViewController()
        for columnIdentifier in RecordTableColumn.allCases {
            let column = NSTableColumn(identifier: .init(rawValue: columnIdentifier.rawValue))
            column.headerCell.title = columnIdentifier.rawValue.capitalized
            column.headerCell.alignment = .center
            controller.tableView.addTableColumn(column)
        }
        controller.tableView.delegate = context.coordinator
        controller.tableView.dataSource = context.coordinator
        return controller
    }

    func updateNSViewController(_ nsViewController: TableViewController, context: Context) {
        nsViewController.tableView.reloadData()
    }
}

extension AccountRecordList {
    enum RecordTableColumn: String, CaseIterable {
        case month
        case contribution
        case withdrawal
        case date
        case balance
        case notes
    }

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var parent: AccountRecordList
        private var records = [Record]()

        init(_ parent: AccountRecordList) {
            self.parent = parent
            records = parent.account.sortedRecords
        }

        // MARK: - NSTableViewDelegate
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let record = records[row]
            guard let identifier = RecordTableColumn(rawValue: tableColumn?.identifier.rawValue ?? "") else {
                return nil
            }

            if row == 0 && [.month, .contribution, .withdrawal].contains(identifier) {
                return ReadonlyCellView()
            }

            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier.rawValue), owner: nil)
            if cell == nil {
                cell = createCell(record: record, columnId: identifier)
            }
            configCell(cell: cell, record: record, columnId: identifier)
            return cell
            // let cell = .environmentObject(parent.portfolioSettings)
            // return NSHostingView(rootView: cell.font(.custom("Arial", size: 13)))
        }

        func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
            26
        }

        // MARK: - NSTableViewDataSource
        func numberOfRows(in tableView: NSTableView) -> Int {
            records.count
        }

        // MARK: - Persistence
        private func save(record: Record) {
            do {
                try parent.viewContext.save()
            } catch {
                parent.viewContext.rollback()
                print("Failed to save, error \(error)")
            }
        }

        private func update(balance: NSDecimalNumber, record: Record, column: RecordTableColumn) {
            if column == .contribution {
                if balance.isEqual(to: record.contribution) {
                    return
                }
                record.contribution = balance
            } else if column == .withdrawal {
                if balance.isEqual(to: record.withdrawal) {
                    return
                }
                record.withdrawal = balance
            } else if column == .balance {
                if balance.isEqual(to: record.balance) {
                    return
                }
                record.balance = balance
            }
            // TODO: other validation before saving?
            save(record: record)
        }

        private func update(notes: String, record: Record) {
            if record.notes == nil || record.notes!.isEmpty {
                if notes.isEmpty {
                    return
                }
            }

            if record.notes != notes {
                record.notes = notes
                save(record: record)
            }
        }

        // MARK: - Cell Builder
        private func createCell(record: Record, columnId: RecordTableColumn) -> NSView? {
            var cell: NSView?
            if [.contribution, .withdrawal, .balance, .notes].contains(columnId) {
                cell = InputCellView()
            } else if [.month, .date].contains(columnId) {
                cell = ReadonlyCellView()
            }
            cell?.identifier = NSUserInterfaceItemIdentifier(rawValue: columnId.rawValue)
            return cell
        }

        private func configCell(cell: NSView?, record: Record, columnId: RecordTableColumn) {
            if [.contribution, .withdrawal, .balance].contains(columnId) {
                let input = cell as! InputCellView
                input.label.alignment = .right
                input.label.stringValue = parent.portfolioSettings.currencyFormatter.outputFormatter.string(from: balance(for: columnId, of: record))
                    ?? parent.portfolioSettings.currencyFormatter.outputFormatter.string(from: 0)!
                // TODO
                /*
                BalanceCell(balance: ) { newValue in
                    self.update(balance: newValue, record: record, column: columnId)
                 */
            } else if columnId == .month {
                let view = cell as! ReadonlyCellView
                view.title = record.monthString
            } else if columnId == .date {
                let view = cell as! ReadonlyCellView
                view.title = record.closeDateString
            } else if columnId == .notes {
                let input = cell as! InputCellView
                input.label.stringValue = record.notes ?? ""
            // TODO
                /*
                NotesCell(notes: record.notes ?? "") { newValue in
                    self.update(notes: newValue, record: record)
                }*/
            }
        }

        private func balance(for columnId: RecordTableColumn, of record: Record) -> NSDecimalNumber {
            var result: NSDecimalNumber?
            if columnId == .contribution {
                result = record.contribution
            } else if columnId == .withdrawal {
                result = record.withdrawal
            } else if columnId == .balance {
                result = record.balance
            }
            return result ?? 0
        }
    }
}

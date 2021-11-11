//
//  CalculationsView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/10.
//

import SwiftUI
import AppKit

struct CalculationsView: NSViewControllerRepresentable {
    typealias NSViewControllerType = TableViewController

    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @ObservedObject var portfolio: Portfolio

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeNSViewController(context: Context) -> TableViewController {
        let controller = TableViewController()
        for columnIdentifier in TableColumn.allCases {
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

extension CalculationsView {
    enum TableColumn: String, CaseIterable {
        case month
        case contribution
        case withdrawal
        case open
        case flow
        case close
        case `return`
    }

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var parent: CalculationsView
        private var returns = [Return]()

        init(_ parent: CalculationsView) {
            self.parent = parent
            returns = parent.portfolio.returns
        }

        // MARK: - NSTableViewDelegate
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let entry = returns[row]
            guard let identifier = TableColumn(rawValue: tableColumn?.identifier.rawValue ?? "") else {
                return nil
            }
            let cell = Text(text(for: entry, row: row, column: identifier))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: identifier == .month ? .center : .trailing)
                .padding(.horizontal, 4)
            return NSHostingView(rootView: cell)
        }

        func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
            26
        }

        // MARK: - NSTableViewDataSource
        func numberOfRows(in tableView: NSTableView) -> Int {
            returns.count
        }

        private var returnFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 1
            return formatter
        }

        // MARK: - Cell contents
        private func text(for entry: Return, row: Int, column: TableColumn) -> String {
            let currencyFormatter = parent.portfolioSettings.currencyFormatter.outputFormatter

            if row == 0 {
                if ![.month, .close].contains(column) {
                    return ""
                }
            }

            switch column {
            case .month:
                return Record.monthFormatter.string(from: entry.closeDate)
            case .contribution:
                return currencyFormatter.string(from: entry.balance.contribution as NSNumber) ?? ""
            case .withdrawal:
                return currencyFormatter.string(from: entry.balance.withdrawal as NSNumber) ?? ""
            case .open:
                return currencyFormatter.string(from: entry.open as NSNumber) ?? ""
            case .flow:
                return currencyFormatter.string(from: entry.flow as NSNumber) ?? ""
            case .close:
                return currencyFormatter.string(from: entry.close as NSNumber) ?? ""
            case .return:
                return returnFormatter.string(from: entry.return as NSNumber) ?? ""
            }
        }
    }
}

//
//  CalculationsView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/10.
//

import SwiftUI
import AppKit
import DGCharts

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
            column.headerCell.title = columnIdentifier.description
            column.headerCell.alignment = .center
            controller.tableView.addTableColumn(column)
        }
        controller.tableView.gridColor = NSColor(Color("ReturnsGreen")).withAlphaComponent(0.3)
        controller.tableView.selectionHighlightStyle = .regular
        controller.tableView.usesAlternatingRowBackgroundColors = true
        controller.tableView.delegate = context.coordinator
        controller.tableView.dataSource = context.coordinator
        return controller
    }

    func updateNSViewController(_ nsViewController: TableViewController, context: Context) {
        nsViewController.tableView.reloadData()
    }
}

extension CalculationsView {
    enum TableColumn: String, CaseIterable, CustomStringConvertible {
        case month
        case contribution
        case withdrawal
        case open
        case flow
        case close
        case growth
        case returnOneMonth
        case returnThreeMonth
        case returnSixMonth
        case returnYtd
        case returnOneYear
        case returnThreeYear
        case returnFiveYear
        case returnTenYear
        case returnFifteenYear
        case returnTwentyYear
        case returnThirtyYear
        case returnFiftyYear

        var description: String {
            switch self {
            case .month:
                return NSLocalizedString("CalculationsTableColumn.month", comment: "Calculations table column")
            case .contribution:
                return NSLocalizedString("CalculationsTableColumn.contirubition", comment: "Calculations table column")
            case .withdrawal:
                return NSLocalizedString("CalculationsTableColumn.withdrawal", comment: "Calculations table column")
            case .open:
                return NSLocalizedString("CalculationsTableColumn.open", comment: "Calculations table column")
            case .flow:
                return NSLocalizedString("CalculationsTableColumn.flow", comment: "Calculations table column")
            case .close:
                return NSLocalizedString("CalculationsTableColumn.close", comment: "Calculations table column")
            case .growth:
                return NSLocalizedString("CalculationsTableColumn.growth", comment: "Calculations table column")
            case .returnOneMonth:
                return NSLocalizedString("1 Month", comment: "Calculations table column")
            case .returnThreeMonth:
                return NSLocalizedString("3 Months", comment: "Calculations table column")
            case .returnSixMonth:
                return NSLocalizedString("6 Months", comment: "Calculations table column")
            case .returnYtd:
                return NSLocalizedString("YTD", comment: "Calculations table column")
            case .returnOneYear:
                return NSLocalizedString("1 Year", comment: "Calculations table column")
            case.returnThreeYear:
                return NSLocalizedString("3 Years", comment: "Calculations table column")
            case.returnFiveYear:
                return NSLocalizedString("5 Years", comment: "Calculations table column")
            case.returnTenYear:
                return NSLocalizedString("10 Years", comment: "Calculations table column")
            case.returnFifteenYear:
                return NSLocalizedString("15 Years", comment: "Calculations table column")
            case.returnTwentyYear:
                return NSLocalizedString("20 Years", comment: "Calculations table column")
            case.returnThirtyYear:
                return NSLocalizedString("30 Years", comment: "Calculations table column")
            case.returnFiftyYear:
                return NSLocalizedString("50 Years", comment: "Calculations table column")
            }
        }
    }

    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var parent: CalculationsView
        private var returns = [Return]()

        init(_ parent: CalculationsView) {
            self.parent = parent
            returns = PortfolioReturn(portfolio: parent.portfolio).returns
        }

        // MARK: - NSTableViewDelegate
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            let entry = returns[row]
            guard let identifier = TableColumn(rawValue: tableColumn?.identifier.rawValue ?? "") else {
                return nil
            }
            var cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier.rawValue), owner: nil) as? LabelCellView
            if cell == nil {
                cell = LabelCellView()
                cell?.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier.rawValue)
            }
            cell?.label.stringValue = text(for: entry, row: row, column: identifier)
            if identifier == .month {
                cell?.label.alignment = .center
            } else {
                cell?.label.alignment = .right
            }
            return cell
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
                if ![.month, .close, .growth].contains(column) {
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
            case .returnOneMonth:
                return returnFormatter.string(from: entry.oneMonthReturn as NSNumber) ?? ""
            case .returnThreeMonth:
                return formatReturn(value: entry.threeMonthReturn)
            case .returnSixMonth:
                return formatReturn(value: entry.sixMonthReturn)
            case .returnYtd:
                return returnFormatter.string(from: entry.ytdReturn as NSNumber) ?? ""
            case .returnOneYear:
                return formatReturn(value: entry.oneYearReturn)
            case .returnThreeYear:
                return formatReturn(value: entry.threeYearReturn)
            case .returnFiveYear:
                return formatReturn(value: entry.fiveYearReturn)
            case .returnTenYear:
                return formatReturn(value: entry.tenYearReturn)
            case .returnFifteenYear:
                return formatReturn(value: entry.fifteenYearReturn)
            case .returnTwentyYear:
                return formatReturn(value: entry.twentyYearReturn)
            case .returnThirtyYear:
                return formatReturn(value: entry.thirtyYearReturn)
            case .returnFiftyYear:
                return formatReturn(value: entry.fiftyYearReturn)
            case .growth:
                return currencyFormatter.string(from: entry.growth * 10_000 as NSNumber) ?? ""
            }
        }

        private func formatReturn(value: Decimal?) -> String {
            if let value = value {
                return returnFormatter.string(from: value as NSNumber) ?? ""
            }
            return ""
        }
    }
}

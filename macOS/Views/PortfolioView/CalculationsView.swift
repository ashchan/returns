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
            case .returnOneMonth:
                return "1 Month"
            case .returnThreeMonth:
                return "3 Months"
            case .returnSixMonth:
                return "6 Months"
            case .returnYtd:
                return "YTD"
            case .returnOneYear:
                return "1 Year"
            case.returnThreeYear:
                return "3 Years"
            case.returnFiveYear:
                return "5 Years"
            case.returnTenYear:
                return "10 Years"
            case.returnFifteenYear:
                return "15 Years"
            case.returnTwentyYear:
                return "20 Years"
            case.returnThirtyYear:
                return "30 Years"
            case.returnFiftyYear:
                return "50 Years"
            default:
                return rawValue.capitalized
            }
        }
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
                .font(.custom("Arial", size: 13))
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

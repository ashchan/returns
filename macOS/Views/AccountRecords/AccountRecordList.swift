//
//  AccountRecordList.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/10/31.
//

import Foundation
import AppKit
import SwiftUI

struct AccountRecordList: NSViewControllerRepresentable {
    typealias NSViewControllerType = MonthlyRecordTableController
    @ObservedObject var account: Account

    func makeNSViewController(context: Context) -> MonthlyRecordTableController {
        return MonthlyRecordTableController(records: account.sortedRecords)
    }

    func updateNSViewController(_ nsViewController: MonthlyRecordTableController, context: Context) {
        nsViewController.reload(records: account.sortedRecords)
    }
}

struct MonthlyRecordList_Previews: PreviewProvider {
    static var previews: some View {
        AccountRecordList(account: Account())
            .frame(width: 400, height: 300)
    }
}

enum RecordTableColumn: String, CaseIterable {
    case month
    case contribution
    case withdrawal
    case date
    case balance
    case notes
}

final class MonthlyRecordTableController: NSViewController {
    private var records: [Record]

    private let tableView: NSTableView = {
        let tableView = NSTableView()

        tableView.usesAlternatingRowBackgroundColors = false
        tableView.selectionHighlightStyle = .none
        tableView.style = .plain
        tableView.gridStyleMask = [.solidHorizontalGridLineMask, .solidVerticalGridLineMask]
        tableView.intercellSpacing = NSSize(width: 0, height: 0)

        for columnIdentifier in RecordTableColumn.allCases {
            let column = NSTableColumn(identifier: .init(rawValue: columnIdentifier.rawValue))
            column.headerCell.title = columnIdentifier.rawValue.capitalized
            column.headerCell.alignment = .center
            tableView.addTableColumn(column)
        }

        tableView.action = #selector(onItemClicked)

        return tableView
    }()

    private let scrollView = NSScrollView()

    init(records: [Record]) {
        self.records = records

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = scrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        scrollView.documentView = tableView
        scrollView.autoresizingMask = [.width, .height]
        scrollView.hasVerticalScroller = true
    }

    func reload(records: [Record]) {
        self.records = records
        tableView.reloadData()
    }

    @objc private func onItemClicked() {
        if tableView.clickedRow < 0 {
            return
        }
    }
}

extension MonthlyRecordTableController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let record = records[row]
        let identifier = RecordTableColumn(rawValue: tableColumn?.identifier.rawValue ?? "")
        if row == 0 && [.month, .contribution, .withdrawal].contains(identifier) {
            return NSHostingView(rootView: NullCell())
        }
        if identifier == .month {
            return NSHostingView(rootView: MonthCell(record: record))
        } else if identifier == .contribution {
            return NSHostingView(rootView: BalanceCell(balance: record.contribution))
        } else if identifier == .withdrawal {
            return NSHostingView(rootView: BalanceCell(balance: record.withdrawal))
        } else if identifier == .date {
            return NSHostingView(rootView: DateCell(record: record))
        } else if identifier == .balance {
            return NSHostingView(rootView: BalanceCell(balance: record.balance))
        } else if identifier == .notes {
            return NSHostingView(rootView: NotesCell(record: record))
        }

        return NSHostingView(rootView: Text(""))
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        26
    }
}

extension MonthlyRecordTableController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        records.count
    }
}

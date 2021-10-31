//
//  MonthlyRecordList.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/10/31.
//

import Foundation
import AppKit
import SwiftUI

struct MonthlyRecordList: NSViewControllerRepresentable {
    typealias NSViewControllerType = MonthlyRecordTableController
    var items = [String]()

    func makeNSViewController(context: Context) -> MonthlyRecordTableController {
        return MonthlyRecordTableController(items: items)
    }

    func updateNSViewController(_ nsViewController: MonthlyRecordTableController, context: Context) {
        nsViewController.reload(items: items)
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyRecordList(items: [])
            .frame(width: 400, height: 300)
    }
}

final class MonthlyRecordTableController: NSViewController {
    private var items: [String]

    private let tableView: NSTableView = {
        let tableView = NSTableView()

        tableView.usesAlternatingRowBackgroundColors = true
        tableView.selectionHighlightStyle = .regular
        tableView.intercellSpacing = NSSize(width: 0, height: 0)

        let columnMonth = NSTableColumn(identifier: .init(rawValue: "month"))
        columnMonth.headerCell.title = "Month"
        tableView.addTableColumn(columnMonth)
        let columnContribution = NSTableColumn(identifier: .init(rawValue: "contribution"))
        columnContribution.headerCell.title = "Contribution"
        tableView.addTableColumn(columnContribution)
        let columnWithdrawal = NSTableColumn(identifier: .init(rawValue: "withdrawal"))
        columnWithdrawal.headerCell.title = "Withdrawal"
        tableView.addTableColumn(columnWithdrawal)
        let columnDate = NSTableColumn(identifier: .init(rawValue: "date"))
        columnDate.headerCell.title = "Date"
        tableView.addTableColumn(columnDate)
        let columnBalance = NSTableColumn(identifier: .init(rawValue: "balance"))
        columnBalance.headerCell.title = "Balance"
        tableView.addTableColumn(columnBalance)

        tableView.action = #selector(onItemClicked)

        return tableView
    }()
    private let scrollView = NSScrollView()

    init(items: [String]) {
        self.items = items

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

    func reload(items: [String]) {
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
        let row = Text("Todo")
        let view = NSHostingView(rootView: row)
        return view
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        32
    }
}

extension MonthlyRecordTableController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        items.count * 100
    }
}

//
//  TableViewController.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/04.
//

import AppKit

final class TableViewController: NSViewController {
    let tableView: NSTableView = {
        let tableView = GridClipTableView()

        tableView.usesAlternatingRowBackgroundColors = false
        tableView.selectionHighlightStyle = .none
        tableView.style = .plain
        tableView.gridStyleMask = [.solidHorizontalGridLineMask, .solidVerticalGridLineMask]
        tableView.intercellSpacing = NSSize(width: 0, height: 0)

        return tableView
    }()

    private let scrollView: NSScrollView = {
        let scrollView = NSScrollView()

        scrollView.autoresizingMask = [.width, .height]
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true

        return scrollView
    }()

    init() {
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

        scrollView.documentView = tableView
    }
}

final class GridClipTableView: NSTableView {
    override func drawGrid(inClipRect clipRect: NSRect) {}
}

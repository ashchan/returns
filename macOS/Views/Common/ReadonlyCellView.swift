//
//  ReadonlyCellView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/22.
//

import AppKit
import SwiftUI

class ReadonlyCellView: NSTableCellView {
    private let label = NSTextField()

    var title: String = "" {
        didSet {
            label.stringValue = title
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createView()
    }

    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    func createView() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        label.isEditable = false
        label.isSelectable = false
        label.drawsBackground = false
        label.isBordered = false
        label.isBezeled = false
        label.lineBreakMode = .byTruncatingTail
        label.font = NSFont(name: "Arial", size: 13)
        label.alignment = .center

        wantsLayer = true
        layer?.backgroundColor = NSColor(Color("readonlyCellColor")).cgColor
    }
}

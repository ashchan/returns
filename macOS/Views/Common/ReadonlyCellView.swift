//
//  ReadonlyCellView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/22.
//

import AppKit
import SwiftUI

class ReadonlyCellView: NSView {
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
        let contentView = ContentView()
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -8),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])

        label.isEditable = false
        label.isSelectable = false
        label.drawsBackground = false
        label.isBordered = false
        label.isBezeled = false
        label.lineBreakMode = .byTruncatingTail
        label.font = NSFont(name: "Arial", size: 13)
        label.alignment = .center
    }
}

extension ReadonlyCellView {
    class ContentView: NSView {
        override func draw(_ dirtyRect: NSRect) {
            super.draw(dirtyRect)

            NSColor(Color("readonlyCellColor")).setFill()
            dirtyRect.fill()
        }
    }
}

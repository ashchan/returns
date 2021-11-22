//
//  InputCellView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/22.
//

import AppKit

class InputCellView: NSView {
    let label = NSTextField()

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

        label.isEditable = true
        label.isSelectable = true
        label.isBordered = false
        label.isBezeled = false
        label.font = NSFont(name: "Arial", size: 13)
    }
}

//
//  InputCellView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/22.
//

import AppKit

class InputCellView: NSView {
    let textField = TextField()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createView()
    }

    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    func createView() {
        addSubview(textField)

        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, constant: -8),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension InputCellView {
    class TextField: NSTextField {
        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)

            isEditable = true
            isSelectable = true
            isBordered = false
            isBezeled = false
            focusRingType = .none
            font = NSFont(name: "Arial", size: 13)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            if let textView = window?.fieldEditor(true, for: nil) as? NSTextView {
                textView.insertionPointColor = .red
            }
            return super.becomeFirstResponder()
        }
    }
}

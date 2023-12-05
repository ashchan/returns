//
//  InputCellView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/22.
//

import AppKit

class InputCellView: NSTableCellView {
    let inputField = TextField()
    var onSubmit: (String) -> Void = { _ in }
    var onValidate: (String) -> String = { v in return v }
    var onEnterKey: () -> Void = {}
    var onTabKey: () -> Void = {}

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        createView()
    }

    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }

    func createView() {
        addSubview(inputField)

        inputField.delegate = self

        inputField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputField.centerXAnchor.constraint(equalTo: centerXAnchor),
            inputField.widthAnchor.constraint(equalTo: widthAnchor, constant: -8),
            inputField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension InputCellView: NSTextFieldDelegate {
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        let newValue = onValidate(inputField.stringValue)
        if newValue != inputField.stringValue {
            inputField.stringValue = newValue
        }
        onSubmit(newValue)
        return true
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            onEnterKey()
        }

        if commandSelector == #selector(NSResponder.insertTab(_:)) {
            onTabKey()
        }

        return false
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

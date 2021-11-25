//
//  Commands.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/25.
//

import SwiftUI

struct DesktopCommands: Commands {
    @AppStorage(NavigationItem.appStorageKeyLastItem) var navigationSelection: String?

    var body: some Commands {
        SidebarCommands()

        CommandGroup(replacing: .newItem, addition: {
            Button("New Portfolio") {
                // TODO
            }
            .keyboardShortcut("N", modifiers: .command)

            Button("New Account") {
                // TODO
            }
            .disabled(!hasSelectedPortfolio)
            .keyboardShortcut("N", modifiers: [.command, .shift])
        })

        CommandGroup(before: .windowArrangement) {
            Button("Main Window") {
                if let window = NSApp.keyWindow {
                    window.orderFront(nil)
                } else {
                    NSWorkspace.shared.open(URL(string: "returnsapp:main")!)
                }
            }
            .keyboardShortcut("0", modifiers: .command)
        }

        CommandGroup(replacing: .windowList, addition: {})
    }

    private var hasSelectedPortfolio: Bool {
        NavigationItem(tag: navigationSelection ?? "").isPortfolio
    }
}

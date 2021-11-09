//
//  ReturnsApp.swift
//  Shared
//
//  Created by James Chen on 2021/07/19.
//

import SwiftUI

@main
struct ReturnsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "main"))
        .commands {
            SidebarCommands()

            CommandGroup(replacing: .newItem, addition: {})
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

        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

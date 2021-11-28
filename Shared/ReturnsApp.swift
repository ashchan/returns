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

    init() {
        rebuildRecordsIfNecessary()
    }

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
            #if os(macOS)
            DesktopCommands()
            #endif
        }

        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

extension ReturnsApp {
    func rebuildRecordsIfNecessary() {
        let fetchRequest: NSFetchRequest<Portfolio> = Portfolio.fetchRequest()
        do {
            let portfolios = try persistenceController.container.viewContext.fetch(fetchRequest)
            portfolios.forEach { $0.rebuildAccountRecords() }
        } catch {
        }
    }
}

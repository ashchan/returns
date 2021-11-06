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
        }
        .commands {
            SidebarCommands()
        }

        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

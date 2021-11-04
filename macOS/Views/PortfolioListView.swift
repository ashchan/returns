//
//  PortfolioListView.swift
//  PortfolioListView
//
//  Created by James Chen on 2021/07/19.
//

import SwiftUI
import CoreData

struct PortfolioListView: View {
    var body: some View {
        NavigationView {
            Sidebar()
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: toggleSidebar) {
                            Image(systemName: "sidebar.left")
                                .help("Toggle Sidebar")
                        }
                    }
                }
                .frame(minWidth: 220, alignment: .leading)

            Text("Welcome")
                .frame(minWidth: 400)
        }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
    }
}

//
//  PortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import SwiftUI

struct PortfolioView: View {
    @ObservedObject var portfolio: Portfolio
    @Binding var showingConfigureSheet: Bool

    var body: some View {
        VStack {
            Text("todo")
        }
        .navigationTitle(portfolio.name ?? "")
        .navigationSubtitle("Since: \(portfolio.sinceString)")
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showingConfigureSheet = true
                } label: {
                    Label("Configure...", systemImage: "folder.badge.gearshape")
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolio: Portfolio(), showingConfigureSheet: .constant(false))
    }
}

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

            Text("Growth Chart")
                .font(.title)
            GrowthChart(portfolio: portfolio)
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
        PortfolioView(portfolio: testPortfolio, showingConfigureSheet: .constant(false))
    }

    static var testPortfolio: Portfolio {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        let account = Account(context: context)
        account.name = "My Account #1"
        account.portfolio = portfolio
        return portfolio
    }
}

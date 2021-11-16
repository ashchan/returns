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
            PortfolioReturnView(portfolioReturn: PortfolioReturn(portfolio: portfolio))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                VStack {
                    Text(growthChartTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    GrowthChart(portfolio: portfolio)
                }
                .frame(height: 220)
                .frame(minWidth: 220)

                VStack {
                    OverviewChart(portfolio: portfolio)
                }
                .frame(width: 220, alignment: .top)
            }
        }
        .padding()
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

    private var growthChartTitle: String {
        let formatter = CurrencyFormatter()
        formatter.currency = portfolio.currency
        return "Growth of " + formatter.outputNoFractionFormatter.string(from: 10_000)!
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

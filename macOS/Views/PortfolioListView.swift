//
//  PortfolioListView.swift
//  PortfolioListView
//
//  Created by James Chen on 2021/07/19.
//

import SwiftUI
import CoreData

struct PortfolioListView: View {
    @AppStorage(NavigationItem.appStorageKeyLastItem) private var selection: String?
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
                .frame(minWidth: 220, alignment: .leading)
        } detail: {
            detailView
                .frame(minWidth: 400)
        }
    }

    @ViewBuilder private var detailView: some View {
        if let account = selectedAccount, let portfolio = account.portfolio {
            AccountDestination(portfolio: portfolio, account: account)
                .id(account.objectID)
        } else if let portfolio = selectedPortfolio {
            if NavigationItem(tag: selection ?? "").isCalculations {
                CalculationsDestination(portfolio: portfolio)
                    .id(portfolio.objectID)
            } else {
                PortfolioOverviewDestination(portfolio: portfolio)
                    .id(portfolio.objectID)
            }
        } else {
            WelcomeView()
        }
    }

}

private extension PortfolioListView {
    var selectedAccount: Account? {
        let item = NavigationItem(tag: selection ?? "")
        guard let uri = item.accountUri,
              let id = viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) else {
            return nil
        }
        return viewContext.object(with: id) as? Account
    }

    var selectedPortfolio: Portfolio? {
        let item = NavigationItem(tag: selection ?? "")
        guard let uri = item.portfolioUri,
              let id = viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) else {
            return nil
        }
        return viewContext.object(with: id) as? Portfolio
    }
}

private struct PortfolioOverviewDestination: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var portfolio: Portfolio
    @StateObject private var portfolioSettings = PortfolioSettings()
    @State private var showingConfigureSheet = false

    var body: some View {
        PortfolioView(portfolio: portfolio, showingConfigureSheet: $showingConfigureSheet)
            .environmentObject(portfolioSettings)
            .sheet(isPresented: $showingConfigureSheet) {
                ConfigurePortfolioView(config: portfolio.config) { config in
                    configure(portfolio: portfolio, config: config)
                }
            }
            .onAppear {
                portfolioSettings.portfolio = portfolio
            }
            .onReceive(portfolio.objectWillChange) { _ in
                DispatchQueue.main.async {
                    portfolioSettings.update()
                }
            }
    }

    private func configure(portfolio: Portfolio, config: PortfolioConfig) {
        portfolio.update(config: config)

        do {
            try viewContext.save()
            portfolioSettings.update()
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }
}

private struct CalculationsDestination: View {
    @ObservedObject var portfolio: Portfolio
    @StateObject private var portfolioSettings = PortfolioSettings()

    var body: some View {
        CalculationsView(portfolio: portfolio)
            .navigationTitle("Calculations")
            .navigationSubtitle("Portfolio: \(portfolio.name ?? "")")
            .environmentObject(portfolioSettings)
            .onAppear {
                portfolioSettings.portfolio = portfolio
            }
            .onReceive(portfolio.objectWillChange) { _ in
                DispatchQueue.main.async {
                    portfolioSettings.update()
                }
            }
    }
}

private struct AccountDestination: View {
    @ObservedObject var portfolio: Portfolio
    @ObservedObject var account: Account
    @StateObject private var portfolioSettings = PortfolioSettings()
    @State private var showingAccountHelpPopover = false

    var body: some View {
        AccountRecordList(account: account)
            .navigationTitle(account.name ?? "")
            .navigationSubtitle("Portfolio: \(portfolio.name ?? "")")
            .toolbar {
                ToolbarItemGroup {
                    Button {
                        showingAccountHelpPopover.toggle()
                    } label: {
                        Label("Configure...", systemImage: "questionmark.circle")
                    }
                    .popover(isPresented: $showingAccountHelpPopover, arrowEdge: .bottom) {
                        AccountHelpPopover()
                    }
                }
            }
            .environmentObject(portfolioSettings)
            .onAppear {
                portfolioSettings.portfolio = portfolio
            }
            .onReceive(portfolio.objectWillChange) { _ in
                DispatchQueue.main.async {
                    portfolioSettings.update()
                }
            }
    }
}

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

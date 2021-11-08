//
//  Sidebar.swift
//  Sidebar
//
//  Created by James Chen on 2021/07/20.
//

import SwiftUI

struct Sidebar: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Portfolio.createdAt, ascending: true)], animation: .default)
    private var portfolios: FetchedResults<Portfolio>
    @State private var showingNewPortfolioSheet = false

    var body: some View {
        VStack {
            List {
                ForEach(portfolios) { portfolio in
                    PortfolioRow(portfolio: portfolio)
                }
            }
            .listStyle(.sidebar)

            Spacer()

            HStack {
                Menu {
                    Button(action: {
                        showingNewPortfolioSheet = true
                    }) {
                        Label("New Portfolio", systemImage: "plus")
                    }
                    Button(action: {
                        // TODO: only if a portfolio is currently selected
                        // addAccount(to: portfolio)
                    }) {
                        Label("New Account", systemImage: "plus")
                    }
                } label: {
                    Label("", systemImage: "plus")
                }
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                .frame(width: 30, height: 30, alignment: .center)
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))

                Spacer()
            }
        }
        .sheet(isPresented: $showingNewPortfolioSheet) {
            ConfigurePortfolioView(config: PortfolioConfig.defaultConfig()) { config in
                addPortfolio(config: config)
            }
        }.contextMenu {
            Button(action: {
                showingNewPortfolioSheet = true
            }) {
                Label("New Portfolio", systemImage: "plus")
            }
        }
    }
}

private extension Sidebar {
    // TODO: update sidebar selection
    func addPortfolio(config: PortfolioConfig) {
        withAnimation {
            let _ = Portfolio.createPortfolio(context: viewContext, config: config)

            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Failed to save, error \(error)")
            }
        }
    }

    // TODO: update sidebar selection
    func addAccount(to portfolio: Portfolio) {
        withAnimation {
            let account = Account(context: viewContext)
            account.createdAt = Date()
            account.portfolio = portfolio
            account.name = "Account #\(portfolio.accounts?.count ?? 0 + 1)"

            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Failed to save, error \(error)")
            }
        }
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

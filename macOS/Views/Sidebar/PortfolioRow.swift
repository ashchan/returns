//
//  PortfolioRow.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

struct PortfolioRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var portfolioSettings = PortfolioSettings()
    @State private var isHeaderHovering = false
    @State private var showingDeletePrompt = false
    @State private var showingConfigureSheet = false
    @State private var showingCalculationsView = false

    @ObservedObject var portfolio: Portfolio

    var body: some View {
        Section(
            header: HStack {
                Text(verbatim: portfolio.name ?? "")
                Spacer()
                if isHeaderHovering {
                    Button(action: {
                        addAccount(to: portfolio)
                    }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(.plain)
                }
            }
                .padding(.bottom, 2)
                .onHover(perform: { isHovering in
                    isHeaderHovering = isHovering
                })
        ) {
            NavigationLink(
                destination: PortfolioView(portfolio: portfolio, showingConfigureSheet: $showingConfigureSheet, showingCalculationsView: $showingCalculationsView)
            ) {
                Label("Overview", systemImage: "chart.pie")
            }
            .alert(isPresented: $showingDeletePrompt) {
                Alert(
                    title: Text(portfolio.name ?? ""),
                    message: Text("Are you sure you want to delete the portfolio?"),
                    primaryButton: .default(Text("Delete")) {
                        delete(portfolio: portfolio)
                    },
                    secondaryButton: .cancel())
            }
            .sheet(isPresented: $showingConfigureSheet) {
                ConfigurePortfolioView(config: portfolio.config) { config in
                    configure(portfolio: portfolio, config: config)
                }
            }
            .contextMenu {
                Button("Configure Portfolio...") {
                    showingConfigureSheet = true
                }
                Divider()
                Button("Add Account") {
                    addAccount(to: portfolio)
                }
                Divider()
                Button("Delete Portfolio...") {
                    showingDeletePrompt = true
                }
            }

            NavigationLink(
                destination: CalculationsView(portfolio: portfolio)
                    .navigationTitle("Calculations")
                    .navigationSubtitle("Portfolio: \(portfolio.name ?? "")")
                    .environmentObject(portfolioSettings),
                isActive: $showingCalculationsView
            ) {
                Label("Calculations", systemImage: "calendar.badge.clock")
            }
            .contextMenu {
                Button("Configure Portfolio...") {
                    showingConfigureSheet = true
                }
                Divider()
                Button("Add Account") {
                    addAccount(to: portfolio)
                }
                Divider()
                Button("Delete Portfolio...") {
                    showingDeletePrompt = true
                }
            }

            ForEach(portfolio.sortedAccounts) { account in
                AccountRow(portfolio: portfolio, account: account)
                    .environmentObject(portfolioSettings)
            }
            .listItemTint(.purple)
        }
        .onAppear {
            portfolioSettings.portfolio = portfolio
        }
    }
}

private extension PortfolioRow {
    // TODO: update sidebar selection
    func delete(portfolio: Portfolio) {
        withAnimation {
            viewContext.delete(portfolio)

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
            account.rebuildRecords()

            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print("Failed to save, error \(error)")
            }
        }
    }

    func configure(portfolio: Portfolio, config: PortfolioConfig) {
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

struct PortfolioRow_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioRow(portfolio: testPortfolio)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }

    static var testPortfolio: Portfolio {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        var account = Account(context: context)
        account.name = "My Account #1"
        account.portfolio = portfolio
        account = Account(context: context)
        account.name = "My Account #2"
        account.portfolio = portfolio
        return portfolio
    }
}

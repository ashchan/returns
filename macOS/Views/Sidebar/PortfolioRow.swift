//
//  PortfolioRow.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

struct PortfolioRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var deletingObject: DeletingObject
    @StateObject var portfolioSettings = PortfolioSettings()
    @State private var isHeaderHovering = false
    @State private var showingConfigureSheet = false

    @ObservedObject var portfolio: Portfolio
    @Binding var selection: String?

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
                destination: PortfolioView(portfolio: portfolio, showingConfigureSheet: $showingConfigureSheet).environmentObject(portfolioSettings),
                tag: "\(portfolio.tag)-overview",
                selection: $selection
            ) {
                Label("Overview", systemImage: "chart.pie")
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
                    deletingObject.deletingInfo = DeletingInfo(type: .portfolio, portfolio: portfolio, account: nil)
                }
            }

            NavigationLink(
                destination: CalculationsView(portfolio: portfolio)
                    .navigationTitle("Calculations")
                    .navigationSubtitle("Portfolio: \(portfolio.name ?? "")")
                    .environmentObject(portfolioSettings),
                tag: "\(portfolio.tag)-calculations",
                selection: $selection
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
                    deletingObject.deletingInfo = DeletingInfo(type: .portfolio, portfolio: portfolio, account: nil)
                }
            }

            ForEach(portfolio.sortedAccounts) { account in
                AccountRow(portfolio: portfolio, account: account, selection: $selection)
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
    func addAccount(to portfolio: Portfolio) {
        let account = PortfolioBuilder.createAccount(context: viewContext, portfolio: portfolio)

        do {
            try viewContext.save()
            selection = account.tag
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
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
        PortfolioRow(portfolio: testPortfolio, selection: .constant(""))
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

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
                    Button(action: addPortfolio) {
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
        }.contextMenu {
            Button(action: addPortfolio) {
                Label("New Portfolio", systemImage: "plus")
            }
        }
    }
}

private extension Sidebar {
    func addPortfolio() {
        withAnimation {
            let portfolio = Portfolio(context: viewContext)
            portfolio.name = "Portfolio #\(portfolios.count + 1)"
            portfolio.createdAt = Date()
            let components = Calendar.current.dateComponents([.year, .month], from: Date())
            portfolio.startYear = Int32(components.year!)
            portfolio.startMonth = Int32(components.month!)

            let account = Account(context: viewContext)
            account.createdAt = Date()
            account.name = "Account #1"
            account.portfolio = portfolio

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func addAccount(to portfolio: Portfolio) {
        withAnimation {
            let account = Account(context: viewContext)
            account.createdAt = Date()
            account.portfolio = portfolio
            account.name = "Account #\(portfolio.accounts?.count ?? 0 + 1)"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
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

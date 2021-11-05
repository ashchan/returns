//
//  PortfolioRow.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/03.
//

import SwiftUI

struct PortfolioRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isHovering = false
    @State private var isCollapsed = false
    @State private var showingDeletePrompt = false
    @State private var showingRenameSheet = false

    @ObservedObject var portfolio: Portfolio

    var body: some View {
        Group {
            NavigationLink(
                destination: PortfolioView(portfolio: portfolio)
            ) {
                ZStack {
                    HStack {
                        Text(verbatim: portfolio.name ?? "Portfolio")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    HStack {
                        Spacer()

                        if isHovering {
                            Button(action: {
                                isCollapsed.toggle()
                            }) {
                                Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 20, height: 20, alignment: .center)
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .onHover(perform: { isHovering in
                self.isHovering = isHovering
            })
            .alert(isPresented: $showingDeletePrompt) {
                Alert(
                    title: Text(portfolio.name ?? ""),
                    message: Text("Are you sure you want to delete the portfolio?"),
                    primaryButton: .default(Text("Delete")) {
                        delete(portfolio: portfolio)
                    },
                    secondaryButton: .cancel())
            }
            .sheet(isPresented: $showingRenameSheet) {
                RenameSheet(name: portfolio.name ?? "", label: "Portfolio name:") { newName in
                    rename(portfolio: portfolio, name: newName)
                }
            }
            .contextMenu {
                Button("New Account") {
                    addAccount(to: portfolio)
                }
                Divider()
                Button("Rename") {
                    showingRenameSheet = true
                }
                Button("Delete") {
                    showingDeletePrompt = true
                }
            }

            if !isCollapsed {
                ForEach(portfolio.sortedAccounts) { account in
                    AccountRow(account: account)
                }
            }
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
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func rename(portfolio: Portfolio, name: String) {
        // TODO: FIXME: accounts list not updated
        portfolio.name = name

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
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

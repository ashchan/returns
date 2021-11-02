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

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default)
    private var items: FetchedResults<Item>
    @State private var loadedItems = [Item]()

    var body: some View {
        VStack {
            List {
                ForEach(portfolios) { portfolio in
                    NavigationLink(
                        destination: PortfolioView(portfolio: portfolio)
                    ) {
                        Text(verbatim: portfolio.name!)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    }
                    .contextMenu {
                        Button(action: {
                            addAccount(to: portfolio)
                        }) {
                            Text("New Account")
                        }
                        Divider()
                        Button(action: {
                            // TODO
                        }) {
                            Text("Rename")
                        }
                        Button(action: {
                            delete(portfolio: portfolio)
                        }) {
                            Text("Delete")
                        }
                    }

                    ForEach(portfolio.sortedAccounts) { account in
                        NavigationLink(
                            destination: MonthlyRecordList(portfolio: portfolio, items: $loadedItems)
                                .navigationTitle("\(portfolio.name!) - \(account.name!)")
                        ) {
                            Text(verbatim: account.name!)
                                .foregroundColor(.primary)
                        }
                        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                        .contextMenu {
                            Button(action: {
                                // TODO
                            }) {
                                Text("Rename")
                            }
                            Button(action: {
                                delete(account: account)
                            }) {
                                Text("Delete")
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)

            Spacer()

            HStack {
                Menu {
                    Button(action: addPortfolio) {
                        Label("New Portfolio", systemImage: "plus")
                    }
                    Button(action: {}) {
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
        }.onAppear {
            loadedItems = items.map { $0 }
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func delete(portfolio: Portfolio) {
        withAnimation {
            viewContext.delete(portfolio)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func delete(account: Account) {
        withAnimation {
            viewContext.delete(account)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

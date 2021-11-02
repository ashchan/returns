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
                        Button(action: {}) {
                            Text("Add Account")
                        }
                        Divider()
                        Button(action: {
                            delete(portfolio: portfolio)
                        }) {
                            Text("Delete Portfolio")
                        }
                    }

                    NavigationLink(
                        destination: MonthlyRecordList(portfolio: portfolio, items: $loadedItems)
                            .navigationTitle("\(portfolio.name!) - Account #1")
                    ) {
                        Text(verbatim: "Account #1")
                            .foregroundColor(.primary)
                    }
                    .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                    .contextMenu {
                        Button(action: {
                            delete(portfolio: portfolio)
                        }) {
                            Text("Delete Account")
                        }
                    }
                }
            }
            .listStyle(.sidebar)

            Spacer()

            HStack {
                Menu {
                    Button(action: addPortfolio) {
                        Label("Add Portfolio", systemImage: "plus")
                    }
                    Button(action: {}) {
                        Label("Add Account", systemImage: "plus")
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

            do {
                try viewContext.save()
                // loadedItems = items.map { $0 }
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
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

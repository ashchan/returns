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

            if !isCollapsed {
                ForEach(portfolio.sortedAccounts) { account in
                    NavigationLink(
                        destination: AccountRecordList(account: account)
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
    }
}

private extension PortfolioRow {
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

    func delete(account: Account) {
        withAnimation {
            viewContext.delete(account)

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
        PortfolioRow(portfolio: Portfolio())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

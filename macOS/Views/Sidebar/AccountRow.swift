//
//  AccountRow.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/05.
//

import AppKit
import SwiftUI
import Combine

struct AccountRow: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var deletingObject: DeletingObject
    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @ObservedObject var portfolio: Portfolio
    @ObservedObject var account: Account
    @State private var showingRenameSheet = false
    @State private var showingAccountHelpPopover = false
    @Binding var selection: String?

    var body: some View {
        NavigationLink(
            destination: AccountRecordList(account: account)
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
                .environmentObject(portfolioSettings),

            tag: account.tag,
            selection: $selection
        ) {
            Label(account.name ?? "", systemImage: "tray.2")
        }
        .sheet(isPresented: $showingRenameSheet) {
            RenameSheet(name: account.name ?? "", label: "Account Name:") { newName in
                rename(account: account, name: newName)
            }
        }
        .contextMenu {
            Button("Rename...") {
                showingRenameSheet = true
            }
            Divider()
            Button("Delete...") {
                deletingObject.deletingInfo = DeletingInfo(type: .account, portfolio: nil, account: account)
            }
        }
    }
}

extension AccountRow {
    func rename(account: Account, name: String) {
        account.name = name

        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }
}

struct AccountHelpPopover: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("For each month, provide three pieces of data:")
                .frame(width: 400, alignment: .leading)
                .padding(5)
            Text("**Total contributions.** \nMoney added to portfolio, excluding any internal cash flows such as dividend payments.")
                .frame(width: 400, alignment: .leading)
                .padding(5)
            Text("**Total withdrawals.** \nMoney removed from portfolio, excluding any internal cash flows such as fees.")
                .frame(width: 400, alignment: .leading)
                .padding(5)
            Text("**Portfolio balance** at the close of the last day of the month.")
                .frame(width: 400, alignment: .leading)
                .padding(5)
        }
        .padding()
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(portfolio: testAccount.portfolio!, account: testAccount, selection: .constant(""))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }

    static var testAccount: Account = {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        let account = Account(context: context)
        account.name = "My Account"
        account.portfolio = portfolio
        return account
    }()
}

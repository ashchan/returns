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
    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @ObservedObject var portfolio: Portfolio
    @ObservedObject var account: Account
    @State private var showingDeletePrompt = false
    @State private var showingRenameSheet = false
    @Binding var selection: String?

    var body: some View {
        NavigationLink(
            destination: AccountRecordList(account: account)
                .navigationTitle(account.name ?? "")
                .navigationSubtitle("Portfolio: \(portfolio.name ?? "")")
                .environmentObject(portfolioSettings),
            tag: account.tag,
            selection: $selection
        ) {
            Label(account.name ?? "", systemImage: "tray.2")
        }
        .alert(isPresented: $showingDeletePrompt) {
            Alert(
                title: Text(account.name ?? ""),
                message: Text("Are you sure you want to delete the account?"),
                primaryButton: .default(Text("Delete")) {
                    delete(account: account)
                },
                secondaryButton: .cancel())
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
                showingDeletePrompt = true
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

    func delete(account: Account) {
        withAnimation {
            viewContext.delete(account)

            do {
                try viewContext.save()
                selection = portfolio.tag + "-overview"
            } catch {
                viewContext.rollback()
                print("Failed to save, error \(error)")
            }
        }
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

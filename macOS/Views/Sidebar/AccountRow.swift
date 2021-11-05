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
    @ObservedObject var account: Account
    @State private var showingDeletePrompt = false
    @State private var showingRenameSheet = false

    var body: some View {
        NavigationLink(
            destination: AccountRecordList(account: account)
                .navigationTitle("\(account.portfolio?.name ?? "") - \(account.name ?? "")")
        ) {
            Text(verbatim: account.name ?? "")
                .foregroundColor(.primary)
        }
        .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
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
            RenameSheet(name: account.name ?? "", label: "Account name:") { newName in
                rename(account: account, name: newName)
            }
        }
        .contextMenu {
            Button("Rename") {
                showingRenameSheet = true
            }
            Button("Delete") {
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
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func delete(account: Account) {
        // TODO: update sidebar selection
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

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(account: testAccount)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }

    static var testAccount: Account {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        let account = Account(context: context)
        account.name = "My Account"
        account.portfolio = portfolio
        return account
    }
}

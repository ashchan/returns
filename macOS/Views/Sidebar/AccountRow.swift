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
    @State private var isRenaming = false
    
    var body: some View {
        NavigationLink(
            destination: AccountRecordList(account: account)
                .navigationTitle("\(account.portfolio?.name ?? "") - \(account.name ?? "")")
        ) {
            if isRenaming {
                TextField("Account name", text: Binding($account.name)!, onCommit: {
                    isRenaming = false
                    // TODO: save
                })
            } else {
                Text(verbatim: account.name ?? "")
                    .foregroundColor(.primary)
            }
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
        .contextMenu {
            Button(action: {
                isRenaming = true
            }) {
                Text("Rename")
            }
            Button(action: {
                showingDeletePrompt = true
            }) {
                Text("Delete")
            }
        }
    }
}

extension AccountRow {
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

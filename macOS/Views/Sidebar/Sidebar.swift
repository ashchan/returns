//
//  Sidebar.swift
//  Sidebar
//
//  Created by James Chen on 2021/07/20.
//

import SwiftUI

struct Sidebar: View {
    @AppStorage(NavigationItem.appStorageKeyLastItem) var selection: String?
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Portfolio.createdAt, ascending: true)], animation: .default)
    private var portfolios: FetchedResults<Portfolio>
    @State private var showingNewPortfolioSheet = false
    @StateObject private var deletingObject = DeletingObject()

    var body: some View {
        VStack {
            List {
                ForEach(portfolios) { portfolio in
                    PortfolioRow(portfolio: portfolio, selection: $selection)
                        .environmentObject(deletingObject)
                }
                .padding(.leading, 10)
            }
            .listStyle(.sidebar)

            Spacer()

            HStack {
                Menu {
                    Button(action: {
                        showingNewPortfolioSheet = true
                    }) {
                        Label("New Portfolio", systemImage: "plus")
                    }
                    Button(action: {
                        addAccount()
                    }) {
                        Label("New Account", systemImage: "plus")
                    }
                    .disabled(!hasSelectedPortfolio)
                } label: {
                    Label("", systemImage: "plus")
                }
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 0))
                .frame(width: 30, height: 30, alignment: .center)
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: false))

                Spacer()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .willCreatePortfolioNotification, object: nil)) {_ in
            showingNewPortfolioSheet = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .willCreateSamplePortfolioNotification, object: nil)) {_ in
            addSamplePortfolio()
        }
        .onReceive(NotificationCenter.default.publisher(for: .willCreateAccountNotification, object: nil)) {_ in
            addAccount()
        }
        .alert(item: $deletingObject.deletingInfo) { info in
            Alert(
                title: Text(info.title),
                message: Text(info.message),
                primaryButton: .default(Text("Delete")) {
                    if info.type == .portfolio {
                        delete(portfolio: info.portfolio!)
                    } else {
                        delete(account: info.account!)
                    }
                },
                secondaryButton: .cancel())
        }
        .sheet(isPresented: $showingNewPortfolioSheet) {
            ConfigurePortfolioView(config: PortfolioConfig.defaultConfig()) { config in
                addPortfolio(config: config)
            }
        }
    }
}

private extension Sidebar {
    func addPortfolio(config: PortfolioConfig) {
        let portfolio = PortfolioBuilder.createPortfolio(context: viewContext, config: config)

        do {
            try viewContext.save()
            selection = portfolio.sortedAccounts.first?.tag
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }

    func delete(portfolio: Portfolio) {
        viewContext.delete(portfolio)

        do {
            try viewContext.save()
            selection = ""
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }

    func addAccount() {
        guard let portfolio = selectedPortfolio else { return }
        let account = PortfolioBuilder.createAccount(context: viewContext, portfolio: portfolio)

        do {
            try viewContext.save()
            selection = account.tag
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }

    func delete(account: Account) {
        let tag = account.portfolio!.tag
        viewContext.delete(account)

        do {
            try viewContext.save()
            selection = tag + "-overview"
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }

    func addSamplePortfolio() {
        let portfolio = PortfolioBuilder.createSamplePortfolio(context: viewContext)

        do {
            try viewContext.save()
            selection = portfolio.tag + "-overview"
        } catch {
            viewContext.rollback()
            print("Failed to save, error \(error)")
        }
    }

    var hasSelectedPortfolio: Bool {
        NavigationItem(tag: selection ?? "").isPortfolio
    }

    var selectedPortfolio: Portfolio? {
        let item = NavigationItem(tag: selection ?? "")
        if let uri = item.accountUri,
           let id = viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            if let account = viewContext.object(with: id) as? Account {
                return account.portfolio
            }
        }
        if let uri = item.portfolioUri,
           let id = viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri),
           let portfolio = viewContext.object(with: id) as? Portfolio {
            return portfolio
        }
        return nil
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

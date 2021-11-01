//
//  PortfolioListView.swift
//  PortfolioListView
//
//  Created by James Chen on 2021/07/19.
//

import SwiftUI
import CoreData

struct PortfolioListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var loadedItems = [Item]()

    var body: some View {
        NavigationView {
            Sidebar()
                .toolbar {
                    ToolbarItemGroup {
                        Button(action: toggleSidebar) {
                            Image(systemName: "sidebar.left")
                                .help("Toggle Sidebar")
                        }
                    }
                    ToolbarItemGroup {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .frame(minWidth: 220, alignment: .leading)

            MonthlyRecordList(items: $loadedItems)

            /*
            List {
                ForEach(items) { item in
                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                }
                .onDelete(perform: deleteItems)
            }*/
        }.onAppear {
            loadedItems = items.map { $0 }
        }
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?
            .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
                loadedItems = items.map { $0 }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PortfolioListView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

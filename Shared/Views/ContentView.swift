//
//  ContentView.swift
//  Shared
//
//  Created by James Chen on 2021/07/19.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        PortfolioListView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

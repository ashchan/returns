//
//  WelcomeView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/27.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var portfolios: FetchedResults<Portfolio>

    var body: some View {
        if portfolios.isEmpty {
            VStack {
                Button("Create your first portfolio") {
                    NotificationCenter.default.post(name: .willCreatePortfolioNotification, object: nil)
                }

                HStack {
                    Text("or")
                    Button("generate a sample portfolio") {
                        NotificationCenter.default.post(name: .willCreateSamplePortfolioNotification, object: nil)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }
            }
        } else {
            Text("No Portfolio Selected")
                .font(.title)
                .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

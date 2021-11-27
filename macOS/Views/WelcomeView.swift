//
//  WelcomeView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/27.
//

import SwiftUI

struct WelcomeView: View {
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var portfolios: FetchedResults<Portfolio>

    var body: some View {
        if portfolios.isEmpty {
            VStack {
                HStack {
                    Button("Create your first portfolio") {
                        NotificationCenter.default.post(name: .willCreatePortfolioNotification, object: nil)
                    }
                    Text("to get started,")
                }

                HStack {
                    Text("or")
                    Button("generate a sample portfolio") {
                        NotificationCenter.default.post(name: .willCreateSamplePortfolioNotification, object: nil)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                    Text("to see how it works.")
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

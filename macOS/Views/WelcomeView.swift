//
//  WelcomeView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/27.
//

import SwiftUI

struct WelcomeView: View {
    @FetchRequest(sortDescriptors: [])
    private var portfolios: FetchedResults<Portfolio>

    var body: some View {
        if portfolios.isEmpty {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    Image(nsImage: NSImage(named: "AppIcon")!)
                        .resizable()
                        .frame(width: 80, height: 80)
                }

                Text("How to get started")
                    .font(.headline)

                BulletPointView(icon: "chart.pie", text: "1. Create a portfolio.")
                BulletPointView(icon: "tray.2", iconColor: .purple, text: "2. Add one or more accounts.")
                BulletPointView(icon: "calendar.badge.clock", text: "3. At the close of the last day of each month, add **total contributions**, **total withdrawals** and **account balance** to each account.")
                BulletPointView(icon: "brain.head.profile", iconColor: .red, text: "4. Sleep well. Do not watch your portfolio. Let it perform.")

                HStack {
                    Button("Create your first portfolio") {
                        NotificationCenter.default.post(name: .willCreatePortfolioNotification, object: nil)
                    }
                    .font(.body.bold())
                    Text("or")
                    Button("generate a sample portfolio") {
                        NotificationCenter.default.post(name: .willCreateSamplePortfolioNotification, object: nil)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(.accentColor)
                }

                if #available(macOS 12, *) {
                    Text("This app is inspired by and based on the [return spreadsheet](https://www.bogleheads.org/forum/viewtopic.php?f=10&t=150025) built by Bogleheads forum member longinvest. To learn more about how it computes returns, see Bogleheads wiki page [Calculating personal returns](https://www.bogleheads.org/wiki/Calculating_personal_returns).")
                } else {
                    Text("This app is inspired by and based on the return spreadsheet built by Bogleheads forum member longinvest. To learn more about how it computes returns, see Bogleheads wiki page Calculating personal returns.")
                }

                Spacer()
            }
            .padding()
        } else {
            Text("No Portfolio Selected")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }

    struct BulletPointView: View {
        var icon: String
        var iconColor: Color?
        var text: String

        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(iconColor ?? .accentColor)
                Text(.init(text))
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//
//  Settings.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/06.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showBalanceOnPortfolioOverview") var showBalanceOnPortfolioOverview = true
    @AppStorage("upsDownsColor") var upsDownsColor = UpsDownsColor.greenUp

    var body: some View {
        Form {
            Toggle("Show balance on Overview page", isOn: $showBalanceOnPortfolioOverview)

            Picker("Ups/Downs Color:", selection: $upsDownsColor) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .renderingMode(.template)
                        .foregroundColor(Color("PriceGreen"))
                    Text("Green up")
                }.tag(UpsDownsColor.greenUp)

                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .renderingMode(.template)
                        .foregroundColor(Color("PriceRed"))
                    Text("Red up")
                }.tag(UpsDownsColor.redUp)
            }
            .fixedSize()
            .pickerStyle(.inline)
        }
        .padding(20)
        .frame(minWidth: 320, alignment: .leading)
    }
}

enum UpsDownsColor: String, CaseIterable, Identifiable {
    var id: UpsDownsColor { self }

    case greenUp
    case redUp
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

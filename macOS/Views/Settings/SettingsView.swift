//
//  Settings.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/06.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showBalanceOnPortfolioOverview") var showBalanceOnPortfolioOverview = true

    var body: some View {
        Form {
            Toggle("Show Balance on Overview Page", isOn: $showBalanceOnPortfolioOverview)
        }
        .padding(20)
        .frame(width: 600, height: 300)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

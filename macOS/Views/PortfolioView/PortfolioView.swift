//
//  PortfolioView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/02.
//

import SwiftUI
import Charts

struct PortfolioView: View {
    @ObservedObject var portfolio: Portfolio
    @Binding var showingConfigureSheet: Bool

    var body: some View {
        VStack {
            Text("todo")

            Text("Growth Chart")
                .font(.headline)
            ZStack {
                Chart(data: portfolio.balanceChartData)
                    .chartStyle(
                        AreaChartStyle(fill: LinearGradient(gradient: .init(colors: [.purple.opacity(0.4), .purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                    )
                Chart(data: portfolio.balanceChartData)
                    .chartStyle(LineChartStyle(lineColor: .purple, lineWidth: 2))
            }.padding()
        }
        .navigationTitle(portfolio.name ?? "")
        .navigationSubtitle("Since: \(portfolio.sinceString)")
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showingConfigureSheet = true
                } label: {
                    Label("Configure...", systemImage: "folder.badge.gearshape")
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView(portfolio: Portfolio(), showingConfigureSheet: .constant(false))
    }
}

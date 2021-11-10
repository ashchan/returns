//
//  GrowthChart.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/08.
//

import SwiftUI
import Charts

struct GrowthChart: View {
    @State var portfolio: Portfolio
    var body: some View {
        VStack {
            Text("Growth Chart")
                .font(.headline)

            HStack {
                VStack {
                    AxisLabels(.vertical, data: (-10...10).reversed(), id: \.self) {
                        Text("\($0 * 10)")
                            .fontWeight(.bold)
                            .font(Font.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 20)

                    Rectangle().foregroundColor(.clear).frame(width: 20, height: 20)
                }

                ZStack {
                    Chart(data: ChartData(portfolio: portfolio).balanceData)
                        .chartStyle(
                            AreaChartStyle(fill: LinearGradient(gradient: .init(colors: [.purple.opacity(0.4), .purple.opacity(0.05)]), startPoint: .top, endPoint: .bottom))
                        )
                    Chart(data: ChartData(portfolio: portfolio).balanceData)
                        .chartStyle(LineChartStyle(lineColor: .purple, lineWidth: 2))
                }
                .padding()
            }
        }
    }
}

struct GrowthChart_Previews: PreviewProvider {
    static var previews: some View {
        GrowthChart(portfolio: testPortfolio)
    }

    static var testPortfolio: Portfolio {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        var account = Account(context: context)
        account.name = "My Account #1"
        account.portfolio = portfolio
        account = Account(context: context)
        account.name = "My Account #2"
        account.portfolio = portfolio
        return portfolio
    }
}

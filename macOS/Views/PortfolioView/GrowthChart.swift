//
//  GrowthChart.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/08.
//

import SwiftUI
import Charts

struct GrowthChart: NSViewRepresentable {
    @State var portfolio: Portfolio

    typealias NSViewType = LineChartView

    func makeNSView(context: Context) -> LineChartView {
        let view = LineChartView()
        view.data = chartData
        return view
    }

    func updateNSView(_ nsView: LineChartView, context: Context) {
        nsView.data = chartData
    }
}

extension GrowthChart {
    var chartData: LineChartData {
        let entries = ChartData(portfolio: portfolio).balanceData.enumerated().map { (index, balance) in
            ChartDataEntry(x: Double(index), y: balance)
        }
        let dataSet = LineChartDataSet(entries: entries)
        return LineChartData(dataSets: [dataSet])
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

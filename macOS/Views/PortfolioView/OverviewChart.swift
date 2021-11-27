//
//  OverviewChart.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/10.
//

import SwiftUI
import Charts

struct OverviewChart: NSViewRepresentable {
    @AppStorage("showBalanceOnPortfolioOverview") var showBalance = true
    @State var portfolio: Portfolio

    typealias NSViewType = PieChartView

    func makeNSView(context: Context) -> PieChartView {
        let view = PieChartView()
        view.usePercentValuesEnabled = true
        view.chartDescription.text = ""
        view.drawEntryLabelsEnabled = false
        view.rotationEnabled = false
        view.legend.orientation = .vertical
        view.data = chartData
        view.drawHoleEnabled = true

        return view
    }

    func updateNSView(_ nsView: PieChartView, context: Context) {
        nsView.data = chartData
    }
}

extension OverviewChart {
    class ChartValueFormatter: ValueFormatter {
        func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
            Self.formatter.string(from: NSNumber(value: value)) ?? value.description
        }

        static var formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .percent
            formatter.maximumFractionDigits = 1
            formatter.multiplier = 1.0
            return formatter
        }()
    }
}

extension OverviewChart {
    var colors: [NSColor] {
        ChartColorTemplates.material()
    }

    var chartData: PieChartData {
        let formatter = legendBalanceFormatter
        let chartData = ChartData(portfolio: portfolio)
        var entries: [PieChartDataEntry] = chartData.totalAssetsData.map { name, balance in
            var label = name
            if showBalance {
                label = "\(name): \(formatter.string(from: NSNumber(value: balance)) ?? "")"
            }
            return PieChartDataEntry(value: balance, label: label)
        }
        if showBalance {
            entries.append(PieChartDataEntry(
                value: 0,
                label: "Total Assets: \(formatter.string(from: NSNumber(value: chartData.totalBalance)) ?? "")"
            ))
        }
        let dataSet = PieChartDataSet(entries: entries)

        dataSet.selectionShift = 0
        dataSet.label = ""
        dataSet.colors = colors
        let data = PieChartData(dataSets: [dataSet])
        data.setValueFormatter(ChartValueFormatter())
        return data
    }

    var total: String {
        let totalBalance = NSNumber(value: ChartData(portfolio: portfolio).totalBalance)
        return legendBalanceFormatter.string(from: totalBalance) ?? ""
    }

    var legendBalanceFormatter: NumberFormatter {
        let formatter = CurrencyFormatter()
        formatter.currency = portfolio.currency
        return formatter.outputNoFractionFormatter
    }
}

struct OverviewChart_Previews: PreviewProvider {
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

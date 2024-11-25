//
//  GrowthChart.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/08.
//

import SwiftUI
import DGCharts

struct GrowthChart: NSViewRepresentable {
    @EnvironmentObject var portfolioSettings: PortfolioSettings
    @State var portfolio: Portfolio

    typealias NSViewType = LineChartView

    func makeNSView(context: Context) -> LineChartView {
        let view = LineChartView()
        view.leftAxis.axisMinimum = 0
        view.leftAxis.drawGridLinesEnabled = false
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawGridLinesEnabled = false
        view.xAxis.valueFormatter = ChartDateFormatter()
        view.rightAxis.drawLabelsEnabled = false
        view.legend.enabled = false
        view.data = chartData
        if let max = view.data?.yMax {
            view.leftAxis.axisMaximum = max + 2_000
        }
        return view
    }

    func updateNSView(_ nsView: LineChartView, context: Context) {
        nsView.leftAxis.valueFormatter = ChartValueFormatter(portfolio: portfolio)
        nsView.data = chartData
        if let max = nsView.data?.yMax {
            nsView.leftAxis.axisMaximum = max + 2_000
        }
    }
}

extension GrowthChart {
    class ChartDateFormatter: AxisValueFormatter {
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            let date = Date(timeIntervalSince1970: value)
            return Self.formatter.string(from: date)
        }

        static var formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .gregorian)
            formatter.dateFormat = "MM/yyyy"
            formatter.timeZone = .utc
            return formatter
        }()
    }

    class ChartValueFormatter: AxisValueFormatter {
        private var currencyFormatter = CurrencyFormatter()

        init(portfolio: Portfolio) {
            currencyFormatter.currency = portfolio.currency
        }

        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            currencyFormatter.outputNoFractionFormatter.string(from: NSNumber(floatLiteral: value)) ?? value.description
        }
    }
}

extension GrowthChart {
    var colors: [NSColor] {
        [NSColor(Color("ReturnsGreen"))] + ChartColorTemplates.material()
    }

    var chartData: LineChartData {
        let entries = ChartData(portfolio: portfolio).growthData.map { (timestamp, balance) in
            ChartDataEntry(x: timestamp, y: balance)
        }
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 3
        dataSet.drawCirclesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.colors = colors

        let lineChartData = LineChartData(dataSets: [dataSet])
        lineChartData.setDrawValues(false)
        lineChartData.isHighlightEnabled = false
        return lineChartData
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

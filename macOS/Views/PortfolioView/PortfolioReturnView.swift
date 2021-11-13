//
//  PortfolioReturnView.swift
//  Returns (macOS)
//
//  Created by James Chen on 2021/11/13.
//

import SwiftUI

struct PortfolioReturnView: View {
    var returnObject: Return?

    var body: some View {
        if let returnObject = returnObject {
            VStack(alignment: .leading) {
                Text("Portfolio return as of \(Self.dateFormatter.string(from: returnObject.closeDate))")
                    .font(.headline)

                HStack {
                    returnView(label: "1 Month", value: returnObject.oneMonthReturn)
                    if let threeMonthReturn = returnObject.threeMonthReturn {
                        returnView(label: "3 Months", value: threeMonthReturn)
                    }
                    if let sixMonthReturn = returnObject.sixMonthReturn {
                        returnView(label: "6 Months", value: sixMonthReturn)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }

    private func returnView(label: String, value: Decimal) -> some View {
        VStack {
            Text(Self.valueFormatter.string(from: value as NSNumber) ?? "0.0%")
                .font(.headline)
            Text(label)
                .foregroundColor(.gray)
        }.padding()
    }

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter
    }()

    private static var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}

struct PortfolioReturnView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioReturnView(returnObject: testPortfolio.returns.last)
    }

    static var testPortfolio: Portfolio {
        let context = PersistenceController.preview.container.viewContext
        let portfolio = Portfolio(context: context)
        portfolio.name = "My Portfolio"
        let account = Account(context: context)
        account.name = "My Account #1"
        account.portfolio = portfolio
        return portfolio
    }
}